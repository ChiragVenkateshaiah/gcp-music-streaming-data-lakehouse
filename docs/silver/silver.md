# Silver Layer - Cleanede & Structured Events

## Purpose
The Silver layer contains validated, structured, and analytics-ready events derived from the Bronze layer.

This layer is responsible for:
- Enforcing correct data types
- Filtering only relevant events
- Removing obvious data quality issues
- Preparing data for aggregation in the Gold layer
> Design principle: *Make data trustworthy and queryable*

---

## Table: `silver_music_events`
### Schema
| Field Name       | Type      | Description                     |
| ---------------- | --------- | ------------------------------- |
| `event_id`       | STRING    | Unique identifier for the event |
| `user_id`        | STRING    | User who triggered the event    |
| `track_id`       | STRING    | Unique track identifier         |
| `artist`         | STRING    | Track artist                    |
| `event_time`     | TIMESTAMP | Parsed event timestamp          |
| `event_date`     | DATE      | Date derived from event_time    |
| `duration_sec`   | INTEGER   | Playback duration in seconds    |
| `device`         | STRING    | Device type                     |
| `location`       | STRING    | User location                   |
| `ingestion_time` | TIMESTAMP | Time when record was ingested   |

---
## Core Transformation Applied
- `event_time` cast from STRING -> TIMESTAMP
- `event_date` derived from `event_time`
- `duration_sec` cast to INTEGER
- Invalid records filtered out
- Only relevant events retained
- `ingeston_time` added for lineage

---

## Validation Queries (Building Trust in Data)
### 1. Daily Event Volume (Partition Validation)
#### Question: Is data arriving daily and partitioning working?
```sql
SELECT
    event_date,
    COUNT(*) AS total_events
FROM music_analytics.silver_music_events
GROUP BY event_date
ORDER BY event_date;
```
#### Insight:
- Confirms daily ingestion
- Verifies partitioning by `event_date`
---

### 2. Duplicate Event Detection
#### Question: Are there duplicate events after cleaning?
```sql
SELECT
    event_id,
    COUNT(*) AS record_count
FROM silver_music_events
GROUP BY event_id
HAVING record_count > 1;
```
#### Insight:
- Ensures correctness before aggregation
- Prevents inflated Gold metrics

---
### 3. Duration Sanity Check
#### Question: Are playback durations realistic?
```sql
SELECT
    MIN(duration_sec) AS min_duration,
    MAX(duration_sec) AS max_duration,
    AVG(duration_sec) AS avg_duration
FROM silver_music_events;
```
#### Insight:
- Builds confidence in engagement metrics
- Detects outliers early

---

### 4. Engagement Snapshot (Users vs Plays)
#### Question: How many users and plays occur each day?
```sql
SELECT
    event_date,
    COUNT(*) AS total_plays,
    COUNT(DISTINCT user_id) AS unique_users
FROM silver_music_events
GROUP BY event_date
ORDER BY event_date;
```
#### Insight:
- Forms the basis for Gold aggregations
- Helps validate business logic

---
### 5. Late-Arriving Data Analysis
#### Question: How delayed are events relative to ingestion?
```sql
SELECT
    event_date,
    TIMESTAMP_DIFF(ingestion_time, event_time, HOUR) AS delay_hours
FROM silver_music_events
ORDER BY delay_hours DESC
LIMIT 20;
```
#### Insight:
- Identifies late data
- Important for incremental Gold processing

---
## Why These Checks Matter in Silver
| Check                | Reason                          |
| -------------------- | ------------------------------- |
| Partition validation | Cost & performance optimization |
| Duplicate detection  | Metric accuracy                 |
| Duration validation  | Engagement correctness          |
| User vs play ratio   | Data sanity                     |
| Late data analysis   | Reliable aggregations           |

> Silver ensures correctness before aggregation.

---
## Transition to Gold Layer
Silver data is now:
- Typed
- Filtered
- Partitioned
- Trusted

### This allows the Gold layer to:
- Aggregate safely
- Produce business KPIs
- Power dashboards and reporting

---

## Summary
- Silver is the contract between raw data and analytics
- It enforces quality and structure
- Mistakes here propagate to Gold - so correctness is critical

