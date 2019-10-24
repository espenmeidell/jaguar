provider "google" {
  project = "gcp-certification-254910"
  region  = "europe-west3"
}

resource "google_bigquery_dataset" "cartrips" {
  dataset_id    = "cartrips"
  friendly_name = "Car trips"
  location      = "EU"
}

resource "google_bigquery_table" "waypoints" {
  dataset_id = "${google_bigquery_dataset.cartrips.dataset_id}"
  table_id   = "waypoints"
  time_partitioning {
    type  = "DAY"
    field = "timestamp"
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
    "type": "FLOAT64",
    "mode": "REQUIRED"
  },
  {
    "name": "longitude",
    "type": "FLOAT64",
    "mode": "REQUIRED"
  }
]
EOF
}

resource "google_bigquery_table" "trips" {
  dataset_id = "${google_bigquery_dataset.cartrips.dataset_id}"
  table_id   = "trips"

  schema = <<EOF
[
  {
    "name": "tripid",
    "type": "STRING",
    "mode": "REQUIRED"
  },
  {
    "name": "averageEnergyConsumption",
    "type": "FLOAT64",
    "mode": "REQUIRED"
  },
  {
    "name": "averageSpeed",
    "type": "FLOAT64",
    "mode": "REQUIRED"
  },
  {
    "name": "distance",
    "type": "INT64",
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
    "type": "FLOAT64",
    "mode": "REQUIRED"
  },
  {
    "name": "startLongitude",
    "type": "FLOAT64",
    "mode": "REQUIRED"
  },
    {
    "name": "endLatitude",
    "type": "FLOAT64",
    "mode": "REQUIRED"
  },
  {
    "name": "endLongitude",
    "type": "FLOAT64",
    "mode": "REQUIRED"
  }
]
EOF

}
