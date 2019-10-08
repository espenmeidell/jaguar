import jlrpy
from pprint import pprint
import json


def connect():
    c = jlrpy.Connection('', '')
    v = c.vehicles[0]
    trips = v.get_trips(2000)['trips']
    counter = 0
    # for trip in trips:
    #     print(f"Processing trip {counter} of {len(trips)}")
    #     try:
    #         trip['waypoints'] = v.get_trip(trip['id'])['waypoints']
    #         with open(f"trips/{trip['id']}.json", "w") as f:
    #             f.write(json.dumps(trip, indent=2))
    #     except:
    #         print(f"Error processing trip: {trip['id']}")
    #     counter += 1
    print(len(trips))


if __name__ == "__main__":
    connect()

"""
Errors:
1684181356
1647881228
1543506667
1510452154
1486132843
1196821603
"""
