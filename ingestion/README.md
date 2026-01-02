# Ingestion Layer

### Authenticate with GCP
```gcloud
gcloud auth login
```

### Set active project
```gcloud
gcloud config set project <PROJECT_ID>
```

### Create GCS bucket (globally unique name)
```gcloud
gsutil mb -l asia-south1 gs://<your-name>-music-streaming-datalake
```

### Upload raw music events to Bronze layer
```gcloud
gsutil cp data/music_events.json \
gs://<your-name>-music-streaming-datalake/music_events/ingestion_date=2026-01-01/
```

### Why These Commands:
`gcloud auth login` - Secure authentication
`gsutil mb` - Creates durable object storage
`gsutil cp` - Append-only ingestion
`ingestion_date` - Enables replay & auditability


## Run the Script
```bash
chmod +x ingestion/ingestion_bronze.sh
./ingestion/ingest_bronze.sh
```


## Bronze Layer Ingestion (GCS)

Raw music streaming events are ingested into Google Cloud Storage using a shell script

### Ingestion Script
`ingestion/ingest_bronze.sh`

### Key Characteristics
- Append-only ingestion
- Partitioned by ingestion_date
- Reproducible & automated
