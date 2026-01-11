#!/bin/bash
set -e


PROJECT_ID=$(gcloud config get-value project)
DATASET="music_analytics"
TABLE="bronze_music_events"
BUCKET="chirag-music-streaming-datalake"
GCS_PATH="bronze/music_events/ingestion_date=2026-01-01/*.json"
SCHEMA_PATH="sql/schemas/bronze_music_events_schema.json"

echo "Using GCP Project: ${PROJECT_ID}"
echo "Loading GCS -> Bronze table..."

# ====== CHECK IF TABLE EXISTS =========
if bq show ${DATASET}.${TABLE} 2>/dev/null 2>&1; then
    echo "Bronze table already exists"
else
    echo "Creating Bronze table..."
    bq mk --table \
        --schema=${SCHEMA_PATH} \
        $DATASET.$TABLE

fi


# ============= LOAD DATA =============
bq load \
    --source_format=NEWLINE_DELIMITED_JSON \
    $DATASET.$TABLE \
    gs://${BUCKET}/${GCS_PATH} \

echo "✅ Bronze ingestion completed"
