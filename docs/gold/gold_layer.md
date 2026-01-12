# Gold Layer

## Purpose
The Gold layer contains business-ready aggregated metrics derived from the Silver layer. These metrics are designed to support analytics, reporting, and decision-making
It is designed for:
- Analytics & reporting
- Dashboards
- Trend analysis
- Decision-making

> Design principle: *Aggregate once, use everywhere*

---

## Source Table
- Input: `silver_music_events`
- Granularity: Event-level (one row per play)

---

## Gold Table: `gold_daily_track_metrics`
### Schema
| Field                 | Type    | Description                   |
| --------------------- | ------- | ----------------------------- |
| `event_date`          | DATE    | Metric date (partition key)   |
| `track_id`            | STRING  | Track identifier              |
| `artist`              | STRING  | Artist name                   |
| `total_plays`         | INTEGER | Total plays per track per day |
| `unique_users`        | INTEGER | Distinct listeners            |
| `total_listening_sec` | INTEGER | Total listening time          |

---

## Transformation Logic (Silver -> Gold)
| Metric                | Calculation               |
| --------------------- | ------------------------- |
| `total_plays`         | `COUNT(*)`                |
| `unique_users`        | `COUNT(DISTINCT user_id)` |
| `total_listening_sec` | `SUM(duration_sec)`       |

### Grouped by:
- `event_date`
- `track_id`
- `artist`

---

## Core Gold Aggregation Query
```sql
SELECT
    event_date,
    track_id,
    artist,
    COUNT(*) AS total_plays,
    COUNT(DISTINCT user_id) AS unique_users,
    SUM(duration_sec) AS total_listening_sec
FROM silver_music_events
GROUP BY event_date, track_id, artist;
```
This query defines Gold Layer.

---

## Business Metrics & Insight Queries
### 1. Daily Platform Usage
#### Question: How active is the platform each day?
```sql
SELECT
    event_date,
    SUM(total_plays) AS total_plays,
    SUM(unique_users) AS daily_active_users
FROM gold_daily_track_metrics
GROUP BY event_date
ORDER BY event_date;
```
### Used for:
- Track growth & engagement
- Core KPI for leadership

---
## 2. Top Tracks by Plays
#### Question: Which tracks are most popular?
```sql
SELECT
    track_id,
    artist,
    SUM(total_plays) AS total_plays
FROM gold_daily_track_metrics
GROUP BY track_id, artist
ORDER BY total_plays DESC
LIMIT 10;
```
#### Used for:
- Content promotion
- Playlist decisions

---

## 3. Top Artist by Engagement
#### Question: Which artists drive the most listening?
```sql
SELECT
    artist,
    SUM(total_plays) AS total_plays,
    SUM(unique_users) AS total_listeners
FROM gold_dailyl_track_metrics
GROUP BY artist
ORDER BY total_plays DESC;
```

## 4. Average Listening Time per Play
#### Question: Are users actually listening or skipping?
```sql
SELECT
    event_date,
    ROUND(
        SUM(total_listening_sec) / SUM(total_plays),
        2
    )   AS avg_listen_time_sec
FROM gold_daily_track_metrics
GROUP BY event_date
ORDER BY event_date;
```
#### Insight:
- Proxy for content quality
- Strong engagement signal

---

## 5. Engagement Depth (Plays per User)
#### Question: How engaged are users?
```sql
SELECT
    event_date,
    ROUND(
        SUM(total_plays)/SUM(unique_users),
        2
    ) AS avg_plays_per_user
FROM gold_daily_track_metrics
GROUP BY event_date
ORDER BY event_date;
```

---

## 6. Day-over-Day Growth
#### Question: Is engagement increasing or decreasing?
```sql
SELECT
    event_date,
    total_plays,
    total_plays
        - LAG(total_plays) OVER (ORDER BY event_date) AS daily_growth
FROM (
    SELECT
        event_date,
        SUM(total_plays) AS total_plays
    FROM gold_daily_track_metrics
    GROUP BY event_date
);
```
---

## Gold Data Quality Checks
### Negative or Invalid Metrics
```sql
SELECT *
FROM gold_daily_track_metrics
WHERE total_plays < 0
    OR unique_users < 0
    OR total_listening_sec < 0;
```
---

## Duplicate Daily Records
```sql
SELECT
    event_date,
    track_id,
    COUNT(*) AS record_count
FROM gold_daily_track_metrics
GROUP BY event_date, track_id
HAVNG record_count > 1;
```
---

## Why Gold Exists
> "Gold tables store aggregated, validated metrics optimized for analytics.
> They isolate business logic from raw data and ensure consistent KPIs across dashboards"

---

## Summary
- Bronze - Raw truth
- Silver - Trusted events
- Gold - Business decisions

Gold is where data engineering meets business value



