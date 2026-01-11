SELECT
    event_date,
    track_id,
    ANY_VALUE(artist) AS artist,
    COUNT(*) AS total_plays,
    COUNT(DISTINCT user_id) AS unique_users,
    SUM(duration_sec) AS total_listening_sec
FROM
    music_analytics.silver_music_events
GROUP BY
    event_date,
    track_id;