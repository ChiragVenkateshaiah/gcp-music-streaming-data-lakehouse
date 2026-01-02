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
gcp-music-streaming-data-lakehouse/
│
├── ingestion/          # Data generators, API ingestion
├── transformations/    # Cleaning, silver/gold logic
├── orchestration/      # Airflow DAGs
├── sql/                # BigQuery queries
├── data/               # Sample local data (small only)
├── docs/               # Architecture diagrams
└── README.md
```
