#!/bin/bash
set -e

# ===== CONFIG =====
PROJECT_ID=$(gcloud config get-value project)
DATASET="music_analytics"

BRONZE_TABLE="bronze_music_events"
SILVER_TABLE="silver_music_events"

SCHEMA_PATH="sql/schemas/silverv_music_events_schema.json"
SILVER_SQL_PATH="transformations/silver/silver_music_events.sql"

echo "Using GCP Project: ${PROJECT_ID}"
echo "Deploying Bronze -> Silver pipeline..."

# ===== RECREATE SILVER TABLE (PARTITIONED + CLUSTERED) =====
bq rm -f -t ${DATASET}.${SILVER_TABLE}


bq mk --table \
    --schema=${SCHEMA_PATH} \
    --time_partitioning_field=event_date \
    --time_partitioning_type=DAY \
    --clustering_fields=track_id,user_id \
    ${DATASET}.${SILVER_TABLE}

echo "✅ Silver table created with partitioning & clustering"


# ==== RUN TRANSFORMATION ====
bq query \
  --use_legacy_sql=false \
  --destination_table=${DATASET}.${SILVER_TABLE} \
  --replace=true \
  < $SILVER_SQL_PATH


echo "✅ Silver table refreshed successfully"
