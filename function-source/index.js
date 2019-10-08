const Storage = require("@google-cloud/storage");
const { Datastore } = require("@google-cloud/datastore");

const storage = new Storage();
const bucket = storage.bucket("jag-trip-data-bucket");

const datastore = new Datastore();

exports.processTrip = async (event, context) => {
  console.log(`Processing file: ${event.name}`);
  // Read the file that triggered event
  const file = bucket.file(event.name);
  const buffer = await file.download();
  const fileData = JSON.parse(buffer.toString());
  console.log("Done reading file");

  // Load data into DataStore
  const tripKey = datastore.key(["Trip", fileData.id]);
  const tripDetails = fileData.tripDetails;
  // Delete unused fields
  delete tripDetails.averageFuelConsumption;
  delete tripDetails.averagePHEVFuelConsumption;
  delete tripDetails.electricalConsumption;
  delete tripDetails.electricalRegeneration;
  delete tripDetails.evDistance;
  delete tripDetails.fuelConsumption;
  // Create geopoints
  const startCoordinates = datastore.geoPoint({
    latitude: tripDetails.startPosition.latitude,
    longitude: tripDetails.startPosition.longitude
  });
  const endCoordinates = datastore.geoPoint({
    latitude: tripDetails.endPosition.latitude,
    longitude: tripDetails.endPosition.longitude
  });
  const startAddress = tripDetails.startPosition.address;
  const endAddress = tripDetails.endPosition.address;
  delete tripDetails.startPosition;
  delete tripDetails.endPosition;

  const tripData = {
    ...tripDetails,
    startCoordinates,
    startAddress,
    endCoordinates,
    endAddress
  };
  const tripTask = {
    key: tripKey,
    data: tripData
  };
  await datastore.save(tripTask);

  const waypoints = {};
  for (const wp in fileData.waypoints) {
    waypoints[wp.timestamp] = {
      time: wp.timestamp,
      odo: wp.odometer,
      position: wp.position
    };
  }
  const wayPointTasks = Object.keys(waypoints).map(timestamp => {
    const wpKey = datastore.key(["Trip", fileData.id, "Waypoint", timestamp]);
    return {
      key: wpKey,
      data: waypoints[timestamp]
    };
  });

  if (wayPointTasks.length >= 500) {
    console.log(`${fileData.id}: Too many waypoints. Splitting up.`);
    for (let i = 0; i <= wayPointTasks.length; i += 400) {
      await datastore.save(wayPointTasks.slice(i, i + 400));
    }
  } else {
    await datastore.save(wayPointTasks);
  }

  console.log("Done saving to DataStore");
};
