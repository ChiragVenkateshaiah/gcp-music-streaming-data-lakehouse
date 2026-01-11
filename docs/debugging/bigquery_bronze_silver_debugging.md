# BigQuery Bronze -> Silver Debugging Notes
### Project: GCP Data Engineering - Music Streaming Analytics
### Layer: Bronze & Silver
### Context: Cloud Storage -> BigQuery ingestion & Optimization

---
## 1. Background
During the implementation of the Bronze -> Silver pipeline, multiple issues were encountered related to:
- BigQuery dataset locations
- Missing Bronze layer
- Schema mismatches during JSON ingestion
- Validation of partitioning and clustering metadata

These issues and resolutions reflect real-world BigQuery behavior, not mistakes in SQL Logic.

---
## 2. Issue-1: Silver Pipeline Failed - Bronze Table Not Found
### Error Message
```pgsql
Not Found: Table music_analytics.bronze_music_events was not found in location asia-south1
```
### Root Cause
- Silver transformation queried `bronze_music_events`
- Bronze table did not exist in BigQuery
- Raw data existed only in Cloud Storage

### Key Learning
- Cloud Storage is NOT the Bronze layer.
- Bronze must be queryable BigQuery table.

### Resolution
- Designed and created a Bronze BigQuery table
- Loaded raw JSON data from GCS into Bronze
- Ensured dataset location matched (`asia-south1`)

---

## 3. Issue-2: `--if_not_exists` flag Failing for Tables
### Error Message
```pgsql
Unknown command line flag `if_not_exists`
```
### Root Cause
- BigQuery CLI(`bq`) supports `--if_not_exists` for datasets
- It does NOT support this flag for tables

### Resolution Pattern (Production-Grade)
```bash
if bq show dataset.table >/dev/null 2>&1; then
    echo "Table exists"
else
    bq mk --table ...
fi
```

### Key Learning
> BigQuery table creation must be explicitly state-aware
> There is no `CREATE TABLE IF NOT EXISTS` abstraction

---

## 4. Issue 3: JSON Parsing Error During Bronze Ingestion
### Error Message
```nginx
JSON parsing error: No such field: event_type
```

### Root Cause
- JSON file contained field: `event_type`
- Bronze schema did not define this field
- BigQuery JSON ingestion is schema-strict by default

### Key Learning (Bronze Layer Principle)
> Bronze schema must be a superset of raw data fields

### Resolution
- Inspected raw JSON using:
```bash
gsutil cat gs://bucket/path/file.json | head
```
- Added missing field to Bronze schema
- Dropped and recreated Bronze table
- Re-ran ingestion successfully

---
## 5. Issue-4: Partitioning & Clustering Validation Confusion
### Observed Problems
- `partitioning_type` not recognized
- `clustering_fields` not visible
- `TABLE_OPTIONS` returned no rows

### Root Cause
BigQuery metdata is distributed across multiple sources and not consistently exposed in 'INFORMATION_SCHEMA`

---
## 6. Correct Source of Truth (Important)
✅ Partitioning - Source of Truth
INFORMATION_SCHEMA.COLUMNS
```sql
SELECT
    column_name,
    is_partitioning_column,
    data_type
FROM music_analytics.INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'silver_music_events';
```
### Expected:
```text
event_date | YES | DATE
```
> Partitioning is a column property, not a table flag

---

## ✅ Clustering - Source of Truth
### BigQuery CLI
```bash
bq show --format=prettyjson music_analytics.silver_music_events
```
### Look for:
```json
"clustering": {
    "fields": ["track_id", "user_id"]
}
```
### Why CLI is Trusted:
- INFORMATION_SCHEMA does not always expose clustering
- CLI + UI reflect actual physical table configuration

---

## 7. Final Validation Checklist (Production Standard)
| Feature              | Validation Method                       |
| -------------------- | --------------------------------------- |
| Table exists         | `bq ls dataset`                         |
| Bronze loaded        | `SELECT COUNT(*)`                       |
| Silver deduplication | `GROUP BY event_id HAVING COUNT(*) > 1` |
| Partitioning         | `is_partitioning_column = YES`          |
| Clustering           | `bq show --format=prettyjson`           |
| Cost optimization    | Partition-pruned queries                |


## 8. Final Outcome
After debugging:
- Bronze ingestion is schema-aligned with raw JSON
- Silver table is:
    - Schema-enforced
    - Deduplicated
    - Partitioned by `event_date`
    - Clustered by `track_id`, `user_id`
- Automation scripts are idempotent
- Pipeline reflects real production patterns

## 9. Key Takeaways
- BigQuery datasets are location-bound
- Bronze != Cloud Storage
- JSON ingestion is strict by default
- Partitioning & clustering are create-time decisions
- INFORMATION_SCHEMA is not the sole source of truth
- CLI metadata inspection is often authoritative

