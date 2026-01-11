#!/bin/bash
set -e

DATASET="music_analytics"
TABLE="gold_daily_track_metrics"

echo "Deploying Silver -> Gold pipeline..."

bq rm -f -t ${DATASET}.${TABLE}

bq mk --table \
    --schema=sql/schemas/gold_daily_track_metrics_schema.json \
    --time_partitioning_field=event_date \
    --time_partitioning_type=DAY \
    --clustering_fields=track_id \
    ${DATASET}.${TABLE}


bq query \
    --use_legacy_sql=false \
    --destination_table=${DATASET}.${TABLE} \
    --replace=true \
    < transformations/gold/gold_daily_track_metrics.sql

echo "✅ Gold table created successfully"