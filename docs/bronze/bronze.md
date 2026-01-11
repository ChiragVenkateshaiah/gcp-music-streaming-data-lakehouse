# Bronze Layer - Raw Event Ingestion

## Purpose
The Bronze Layer stores **raw music streaming events** ingested from the source system with **no business logic applied**

This layer acts as:
- A system of record
- A debugging & audit layer
- A replayable source of downstream transformations
> Design principle: *Capture everything, judge nothing*

---

## Table: `bronze_music_events`
### Schema
| Field Name     | Type   | Description                      |
| -------------- | ------ | -------------------------------- |
| `event_id`     | STRING | Unique identifier for the event  |
| `user_id`      | STRING | User who triggered the event     |
| `event_type`   | STRING | Type of event (e.g. play, pause) |
| `track_id`     | STRING | Unique track identifier          |
| `artist`       | STRING | Track artist                     |
| `event_time`   | STRING | Event timestamp as received      |
| `duration_sec` | STRING | Duration of playback             |
| `device`       | STRING | Device type                      |
| `location`     | STRING | User location                    |

---

## Characteristic of Bronze Data
- Raw and unvalidated
- Types reflect source system format
- May contain:
    - Null values
    - Invalid timestamps
    - Duplicate events
- No deduplication or filtering is performed

---

## Exploratory Queries (Understanding Raw Data)
### 1. Event Type Distribution
#### Question: What kinds of events are coming from the source?
```sql
SELECT
    event_type,
    COUNT(*) AS event_count
FROM music_analytics.bronze_music_events
GROUP BY event_type
ORDER BY event_count DESC;
```
#### Insight:
- Helps decide which events are relevant for analytics
- Only relevant events are promoted to Silver

---

### 2. Invalid or Unparseable Timestamps
#### Question: Are event timestamps consistently formatted?
```sql
SELECT
    event_time,
    COUNT(*) AS occurences
FROM music_analytics.bronze_music_events
WHERE SAFE.PARSE_TIMESTAMP('%Y-%m-%d %H:%M:%S', event_time) IS NULL
GROUP BY event_time;
```
#### Insight:
- Justifies timestamp casting logic in Silver
- Confirms source quality issues

---

### 3. Invalid Duration Values
#### Question: Are there missing or invalid durations?
```sql
SELECT *
FROM music_analytics.bronze_music_events
WHERE duration_sec IS NULL
  OR  SAFE_CAST(duration_sec AS INT64) <= 0;
```
#### Insight:
- Bronze exposes issues
- Data is not corrected here

---

## Why These Checks Are Done in Bronze
| Check                | Reason                      |
| -------------------- | --------------------------- |
| Event distribution   | Understand source behavior  |
| Timestamp validity   | Prevent downstream failures |
| Duration sanity      | Protect metric accuracy     |
| Device/location scan | Validate enrichment fields  |

> Bronze is about visibility, not correctness

---

## Transition to Silver Layer
Only events that meet the following criteria are promoted to Silver:
- Valid timestamps
- Valid numeric durations
- Relevant event types (e.g. `play`)
- Required identifiers present

> Silver performs casting, filtering, and enrichment.

---

## Summary
- Bronze captures raw truth
- No assumptions or business rules
- Enables traceability and reprocessing
- Forms the foundation of a reliable pipeline

