resource "google_storage_bucket_iam_member" "gcs_writer" {
  bucket = google_storage_bucket.ais_bronze_layer.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.function_identity.email}"
}

resource "google_project_iam_member" "bq_editor" {
  project = "aispipeline"
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_service_account.function_identity.email}"
}

resource "google_project_iam_member" "bq_job_user" {
  project = "aispipeline"
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.function_identity.email}"
}
