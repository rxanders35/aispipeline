resource "google_service_account" "function_identity" {
  account_id   = "ais-function-identity"
  display_name = "AIS Pipeline Function Service Account"
}

resource "google_service_account" "scheduler_invoker" {
  account_id   = "ais-scheduler-invoker"
  display_name = "AIS Pipeline Scheduler Invoker"
}

resource "google_cloud_run_service_iam_member" "invoker" {
  location = google_cloudfunctions2_function.process_ais_data.location
  project  = google_cloudfunctions2_function.process_ais_data.project
  service  = google_cloudfunctions2_function.process_ais_data.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.scheduler_invoker.email}"
}

resource "google_cloudfunctions2_function" "process_ais_data" {
  name     = "process-daily-ais-data"
  location = "us-east1"

  build_config {
    runtime     = "python311"
    entry_point = "process_ais_csvs"
    source {
      storage_source {
        bucket = google_storage_bucket.ais_bronze_layer.name
        object = google_storage_bucket_object.source_archive_object.name
      }
    }
  }

  service_config {
    max_instance_count    = 3
    min_instance_count    = 0
    available_memory      = "256Mi"
    timeout_seconds       = 540
    service_account_email = google_service_account.function_identity.email
    environment_variables = {
      GCP_PROJECT_ID  = "aispipeline"
      GCP_BUCKET_NAME = google_storage_bucket.ais_bronze_layer.name
      BQ_DATASET_ID   = google_bigquery_dataset.ais_gold_warehouse.dataset_id
      BQ_TABLE_ID     = google_bigquery_table.ais_obt.table_id
    }
  }
}

resource "google_cloud_scheduler_job" "daily_ais_trigger" {
  name      = "daily-ais-pipeline-trigger"
  schedule  = "0 8 * * *" # 8 AM UTC daily
  time_zone = "Etc/UTC"

  http_target {
    uri         = google_cloudfunctions2_function.process_ais_data.service_config[0].uri
    http_method = "POST"

    oidc_token {
      service_account_email = google_service_account.scheduler_invoker.email
    }
  }
}
