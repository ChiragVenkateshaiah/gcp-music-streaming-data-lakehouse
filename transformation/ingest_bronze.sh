#!/bin/bash
set -e

#----------------------------------
# configurable Variables
#----------------------------------
PROJECT_ID="project-id"
BUCKET_NAME="bucket-name"
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


echo "✅ Bronze ingestion completed for data ${INGESTION_DATE}"
