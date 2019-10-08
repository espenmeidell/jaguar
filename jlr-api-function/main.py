import jlrpy
from google.cloud import storage
import os
import json

client = storage.Client()
bucket = client.get_bucket('jag-trip-data-bucket')

def handler(event, context):
    email = os.getenv('JLR_EMAIL', None)
    password = os.getenv('JLR_PASS', None)
    c = jlrpy.Connection(email, password)
    v = c.vehicles[0]
    trips = v.get_trips(10)['trips']
    for trip in trips:
        blob = storage.Blob(bucket=bucket, name=f"{trip['id']}.json")
        already_added = blob.exists()
        print(f"Trip id {trip['id']}. Already added: {already_added}")
        if not already_added:
            print('Loading waypoint data for trip')
            try:
                trip['waypoints'] = v.get_trip(trip['id'])['waypoints']
                fname = f"{trip['id']}.json"
                trip_string = json.dumps(trip, indent=2)
                print(f"Writing to blob {fname}")
                blob.upload_from_string(trip_string)

            except Exception as e:
                print(f"Error processing trip: {trip['id']}")
                print(e)
                

