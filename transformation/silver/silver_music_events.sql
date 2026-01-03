SELECT
 event_id,
 user_id,
 track_id,
 artist,
 TIMESTAMP(event_time) AS event_time,
 DATE(TIMESTAMP(event_time)) AS event_date,
 SAFE_CAST(duration_sec AS INT64) AS duration_sec,
 device,
 location,
 CURRENT_TIMESTAMP() AS ingestion_time
FROM music_analytics.bronze_music_events
WHERE event_id IS NOT NULL
QUALIFY ROW_NUMBER() OVER (
    PARTITION BY event_id
    ORDER BY ingestion_time DESC
) = 1;