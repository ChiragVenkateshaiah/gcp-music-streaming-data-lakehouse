import json
import random
import uuid
from datetime import datetime, timezone



ARTISTS = [
    "A.R. Rahman",
    "Arjith Singh",
    "Taylor Swift",
    "Coldplay",
    "Ed Sheeran"
]


EVENT_TYPES = ["play", "pause", "skip", "like", "complete"]
DEVICES = ["mobile", "desktop", "tablet"]
LOCATIONS = ["IN", "US", "UK", "CA"]



def generate_event():
    return {
        "event_id": str(uuid.uuid4()),
        "user_id": f"user_{random.randint(1, 1000)}",
        "track_id": f"track_{random.randint(1, 500)}",
        "artist": random.choice(ARTISTS),
        "event_type": random.choice(EVENT_TYPES),
        "event_time": datetime.now(timezone.utc).isoformat(),
        "duration_sec": random.randint(30, 300),
        "device": random.choice(DEVICES),
        "location": random.choice(LOCATIONS)
    }

def generate_events(n=1000):
    return [generate_event() for _ in range(n)]


def save_to_file(events, filename):
    with open(filename, "w", encoding="utf-8") as f:
        for event in events:
            f.write(json.dumps(event) + "\n")

if __name__ == "__main__":
    events = generate_events(1000)
    save_to_file(events, "music_events.json")
    print("✅ Generated 1000 music streaming events")