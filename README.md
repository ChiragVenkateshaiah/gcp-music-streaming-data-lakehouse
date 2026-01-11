# 🎵 GCP Music Streaming Data Lakehouse


## Overview
This project demonstrates an end-to-end data lakehouse architecture on Google Cloud Platform using simulated music streaming events.


## Architecture
- Data Generation: Python
- Storage: Google Cloud Storage (Bronze)
- Data Warehouse: BigQuery (Silver & Gold)
- Orchestration: Apache Airflow (Cloud Composer)


# Data Layers
- **Bronze**: Raw music streaming events (JSON)
- **Silver**: Cleansed & Structured events
- **Gold**: Analytical tables for reporting

## Key Concepts
- Event-driven data modeling
- Schema enforcement
- Partitioned & clustered tables
- Batch and streaming design

## Folder Structure
```graphql
gcp-music-streaming-data-lakehouse
├── orchestration/
│   ├── deploy_gcs_to_bronze.sh
│   ├── deploy_bronze_to_silver.sh
│   └── deploy_silver_to_gold.sh
├── sql/
│   └── schemas/
│       ├── bronze_music_events_schema.json
│       ├── silver_music_events_schema.json
│       └── gold_daily_track_metrics_schema.json
├── transformations/
│   ├── silver/
│   └── gold/
├── docs/
│   └── debugging/
│       └── bigquery_bronze_silver_debugging.md
└── README.md

```
