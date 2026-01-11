# 🎵 GCP Music Streaming Data Engineering Pipeline


## Overview
This project implements a **Production-Stype end-to-end** Data Engineering pipeline on Google Cloud Platform (GCP) using a **Bronze-Silver-Gold** architecture.

The pipeline ingest raw music streaming events from **Cloud Storage**, processes and cleans them in **BigQuery**, and produces **business-ready** analytics tables optimized for dashboards and reporting.

The focus of this project is **real-world data engineering practices**, including:
- Schema enforcement
- Handling raw data inconsistencies
- Partitioning & clustering
- Automation using CLI scripts
- Cost-aware BigQuery design
- Debugging production issues

<<<<<<< HEAD
## Folder Structure
```graphql
gcp-music-streaming-data-lakehouse
=======

## High-Level Architecture
```text
Cloud Storage (Raw JSON files)
        ↓
Bronze Layer (BigQuery)
  - Raw, permissive schema
  - Mirrors source data
        ↓
Silver Layer (BigQuery)
  - Cleaned & typed data
  - Deduplicated events
  - Partitioned & clustered
        ↓
Gold Layer (BigQuery)
  - Aggregated KPIs
  - Dashboard-ready tables
```

## Tech Stack
| Category        | Tools                 |
| --------------- | --------------------- |
| Cloud Platform  | Google Cloud Platform |
| Storage         | Cloud Storage         |
| Data Warehouse  | BigQuery              |
| Orchestration   | Bash scripts          |
| Query Language  | Standard SQL          |
| Version Control | GitHub                |
| Execution       | Cloud Shell           |


## Project Structure
```text
.
>>>>>>> 7a718ce (docs: add comprehensive README for end-to-end GCP data engineering pipeline)
├── orchestration/
│   ├── deploy_gcs_to_bronze.sh
│   ├── deploy_bronze_to_silver.sh
│   └── deploy_silver_to_gold.sh
<<<<<<< HEAD
=======
│
>>>>>>> 7a718ce (docs: add comprehensive README for end-to-end GCP data engineering pipeline)
├── sql/
│   └── schemas/
│       ├── bronze_music_events_schema.json
│       ├── silver_music_events_schema.json
│       └── gold_daily_track_metrics_schema.json
<<<<<<< HEAD
├── transformations/
│   ├── silver/
│   └── gold/
├── docs/
│   └── debugging/
│       └── bigquery_bronze_silver_debugging.md
=======
│
├── transformations/
│   ├── silver/
│   │   └── silver_music_events.sql
│   └── gold/
│       └── gold_daily_track_metrics.sql
│
├── docs/
│   └── debugging/
│       └── bigquery_bronze_silver_debugging.md
│
>>>>>>> 7a718ce (docs: add comprehensive README for end-to-end GCP data engineering pipeline)
└── README.md

```

---

## Bronze Layer - Raw Ingestion
### Purpose
- Store raw data in a queryable form
- Preserve source fidelity
- Allow reprocessing and replay

### Source
- Raw JSON files stored in Cloud Storage
```bash
gs://chirag-music-streaming-datalake/bronze/music_events
```
### Key Characteristics
- All fields nullable
- Mostly STRING types
- Schema is a superset of raw JSON
- No deduplication or transformations

### Automation
```bash
./orchestration/deploy_gcs_to_bronze.sh
```

---

## Silver Layer - Clean & Trusted Data
### Purpose
- Enforce data contracts
- Clean and standardize raw events
- Optimize for analytics queries

### Key Transformations
- Type casting (`STRING -> TIMESTAMP / INT`)
- Deduplication using `event_id`
- Time normalization
- Null filtering on required fields
- Audit column (`ingestion_time`)

### Optimizations
- Partitioned by `event_date`
- Clustered by `track_id`, `user_id`

### Automation
```bash
./orchestration/deploy_bronze_to_silver.sh
```

---

## Gold Layer - Business Metrics
### Purpose
- Provide **business-ready KPIs**
- Power dashboards and analytics
- Reduce query cost and complexity

### Gold Table: `gold_daily_track_metrics`

Metric Produced
- Total plays per track per day
- Unique listeners per track per day
- Total listening duration

### Design Choices
- Aggregated data only
- Partitioned by `event-date`
- Clustered by `track_id`
- Small, fast, and stable tables

### Automation
```bash
./orchestration/deploy_silver_to_gold.sh
```

---

## Validation Strategy
### Partitioning Validation
```sql
SELECT
  column_name,
  is_partitioning_column
FROM music_analytics.INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'silver_music_events'
  AND is_partitioning_column = 'YES';
```

### Clustering Validation (Source of Truth)
```bash
bq show --format=prettyjson music_analytics:silver_music_events
```

### Data Quality Checks
```sql
SELECT event_id, COUNT(*)
FROM music_analytics.silver_music_events
GROUP BY event_id
HAVING COUNT(*) > 1;
```

---

## Key Learnings & Real-World Scenarios
- Cloud Storage != Bronze layer
- BigQuery datasets are location-bound
- JSON ingestion is schema-strict by default
- Bronze schema must evolve with raw data
- Partitioning & clustering are **create-time decisions**
- INFORMATION_SCHEMA is not always the source of truth
- CLI(`bq show`) is often authoritative

All major debugging scenarios are documented in:
```bash
docs/debugging/bigquery_bronze_silver_debugging.md
```

---

## Future Enhancements
- Incremental Gold processing (date-based)
- Additional Gold tables (user engagement, device metrics)
- Scheduled execution (Cloud Scheduler / Composer)
- Cost monitoring & Optimization
- Dashboard integration (Looker / Data Studio)

---

## Why This Project Matters
This project demonstrates:
- End-to-end pipeline ownership
- Production debugging skills
- Cost-aware BigQuery design
- Automation-first mindset
- Real Data Engineering patterns

---

## Author
Chirag Venkateshaiah
```text
> Backend Python Developer | Aspiring Data Engineer
```
---
