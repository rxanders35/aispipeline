data "google_project" "project" {}

resource "google_project_iam_member" "bigquery_job_user" {
  project = data.google_project.project.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${data.google_project.project.number}@cloudservices.gserviceaccount.com"
}

resource "google_project_iam_member" "bigquery_data_editor" {
  project = data.google_project.project.project_id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${data.google_project.project.number}@cloudservices.gserviceaccount.com"
}

resource "google_storage_bucket_iam_member" "gcs_object_admin" {
  bucket = google_storage_bucket.ais_bronze_layer.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${data.google_project.project.number}@cloudservices.gserviceaccount.com"
}
