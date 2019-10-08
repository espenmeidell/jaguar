const { Datastore } = require("@google-cloud/datastore");

const datastore = new Datastore();

exports.handler = async (req, res) => {
  const query = datastore.createQuery("Waypoint").select("position");
  const data = await datastore.runQuery(query);
  console.log(data[0].length);
  res.send(data[0].length);
};
