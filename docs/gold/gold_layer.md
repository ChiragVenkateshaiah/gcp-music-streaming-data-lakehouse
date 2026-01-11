# Gold Layer

## Purpose
The Gold layer contains business-ready aggregated metrics derived from the Silver layer. These metrics are designed to support analytics, reporting, and decision-making

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
## How Gold is Derived from Silver
| Silver Field              | Gold Logic            |
| ------------------------- | --------------------- |
| `event_date`              | GROUP BY              |
| `track_id`                | GROUP BY              |
| `artist`                  | GROUP BY              |
| `COUNT(*)`                | `total_plays`         |
| `COUNT(DISTINCT user_id)` | `unique_users`        |
| `SUM(duration_sec)`       | `total_listening_sec` |

> Gold is pure aggregation - no raw fixes

---
## Gold Metrics (High-Level List)
We will produce:
- Daily plays per track
- Daily unique listeners
- Total listening time
- Engagement trends
- Top tracks and artists

---