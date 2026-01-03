# Bronze -> Silver Deployment Script

## Script
```bash
orchestration/deploy_bronze_to_silver.sh
```

## 🎯 Purpose

This script automates the Bronze → Silver transformation in BigQuery by:
- Ensuring the Silver table exists using a predefined schema
- Running a transformation query to clean and normalize Bronze data
- Replacing the Silver table in an idempotent way
- This follows a Lakehouse-style data layering approach.

## Dependencies (Repo Paths)
The script depends on the following files:
```text
sql/schemas/silver_music_events_schema.json
transformation/silver/silver_music_events.sql
```


## Authentication
- Uses exisiting gcloud authentication
- No credentials are stored in the repository
- project is resolved via:
```bash
gcloud config get-value project
```

## Make this Script executable (One time)
```bash
chmod +x orchestration/deploy_bronze_to_silver.sh
```

## Run the Script
from the repository root:
```bash
./orchestartion/deploy_bronze_to_silver.sh
```

## Expected Output
```text
Using GCP Project: <project-id>
Deploying Bronze → Silver pipeline...
Silver table refreshed successfully
```