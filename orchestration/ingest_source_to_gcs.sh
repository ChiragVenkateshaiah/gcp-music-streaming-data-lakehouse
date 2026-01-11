#!/bin/bash
set -e

#----------------------------------
# configurable Variables
#----------------------------------
PROJECT_ID="secure-guru-482507-k3"
BUCKET_NAME="chirag-music-streaming-datalake"
INGESTION_DATE=$(date +%F)
LOCAL_FILE="data/music_events.json"


#---------------------------------
# Authenticate & Set Project
# -------------------------------
gcloud config set project ${PROJECT_ID}


#----------------------------------
# Upload to GCS Bronze layer
#----------------------------------
gsutil cp ${LOCAL_FILE} \
gs://${BUCKET_NAME}/bronze/music_events/ingestion_date=${INGESTION_DATE}/


echo "✅ Source ingestion to bronze layer is completed for data ${INGESTION_DATE}"
