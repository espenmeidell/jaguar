
resource "google_pubsub_topic" "trip-topic" {
  name = "trip-topic"
  labels = {
    terraform = "true"
  }
}

resource "google_pubsub_subscription" "trip-sub" {
  name  = "trip-sub"
  topic = "${google_pubsub_topic.trip-topic.name}"

  ack_deadline_seconds = 20

}



resource "google_storage_bucket" "jlr-dataflow-tmp-bucket" {
  name     = "jlr-dataflow-tmp-bucket"
  location = "EU"
}

resource "google_dataflow_job" "trip-to-bq-job" {
  name              = "trip-to-bq-job"
  template_gcs_path = "gs://dataflow-templates/latest/PubSub_Subscription_to_BigQuery"
  temp_gcs_location = "${google_storage_bucket.jlr-dataflow-tmp-bucket.url}"
  parameters = {
    inputSubscription = "${google_pubsub_subscription.trip-sub.path}"
    outputTableSpec   = "${google_bigquery_table.trips.project}:${google_bigquery_table.trips.dataset_id}.${google_bigquery_table.trips.table_id}"
  }
}
