provider "google" {
  project = "gcp-certification-254910"
  region  = "europe-west1"
  zone    = "europe-west1-b"
}

resource "google_bigquery_dataset" "cartrips" {
  dataset_id    = "cartrips"
  friendly_name = "Car trips"
  location      = "EU"
  labels = {
    terraform = "true"
  }
}

resource "google_bigquery_table" "waypoints" {
  dataset_id = "${google_bigquery_dataset.cartrips.dataset_id}"
  table_id   = "waypoints"
  time_partitioning {
    type  = "DAY"
    field = "timestamp"
  }
  labels = {
    terraform = "true"
  }

  schema = <<EOF
[
  {
    "name": "tripid",
    "type": "STRING",
    "mode": "REQUIRED"
  },
  {
    "name": "timestamp",
    "type": "TIMESTAMP",
    "mode": "REQUIRED"
  },
  {
    "name": "latitude",
    "type": "FLOAT",
    "mode": "REQUIRED"
  },
  {
    "name": "longitude",
    "type": "FLOAT",
    "mode": "REQUIRED"
  }
]
EOF
}

resource "google_bigquery_table" "trips" {
  dataset_id = "${google_bigquery_dataset.cartrips.dataset_id}"
  table_id   = "trips"
  labels = {
    terraform = "true"
  }

  schema = <<EOF
[
  {
    "name": "tripid",
    "type": "STRING",
    "mode": "REQUIRED"
  },
  {
    "name": "averageEnergyConsumption",
    "type": "FLOAT",
    "mode": "REQUIRED"
  },
  {
    "name": "averageSpeed",
    "type": "FLOAT",
    "mode": "REQUIRED"
  },
  {
    "name": "distance",
    "type": "INTEGER",
    "mode": "REQUIRED"
  },
  {
    "name": "startAddress",
    "type": "STRING",
    "mode": "REQUIRED"
  },
  {
    "name": "endAddress",
    "type": "STRING",
    "mode": "REQUIRED"
  },
  {
    "name": "startTime",
    "type": "TIMESTAMP",
    "mode": "REQUIRED"
  },
  {
    "name": "endTime",
    "type": "TIMESTAMP",
    "mode": "REQUIRED"
  },
  {
    "name": "startLatitude",
    "type": "FLOAT",
    "mode": "REQUIRED"
  },
  {
    "name": "startLongitude",
    "type": "FLOAT",
    "mode": "REQUIRED"
  },
    {
    "name": "endLatitude",
    "type": "FLOAT",
    "mode": "REQUIRED"
  },
  {
    "name": "endLongitude",
    "type": "FLOAT",
    "mode": "REQUIRED"
  }
]
EOF

}
