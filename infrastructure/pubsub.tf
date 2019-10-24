
resource "google_pubsub_topic" "trip-topic" {
  name = "trip-topic"
  labels = {
    terraform = "true"
  }
}

resource "google_pubsub_topic" "trigger-jlr-api-call" {
  name = "trigger-jlr-api-call"
  labels = {
    terraform = "true"
  }
}

resource "google_cloud_scheduler_job" "check-jlr-api" {
  name        = "check-jlr-api"
  description = "Check JLR api for new trip"
  schedule    = "0 1 * * *"
  pubsub_target {
    topic_name = "${google_pubsub_topic.trigger-jlr-api-call.id}"
    data       = "${base64encode("check")}"
  }
}
