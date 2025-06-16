data "archive_file" "source_zip" {
  type        = "zip"
  source_dir  = "../backend"
  output_path = "${path.module}/source.zip"
}



resource "google_cloudfunctions2_function" "process_ais_data" {
  name     = "process_ais_data"
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
    timeout_seconds  = 540
    available_memory = "512MiB"
    environment_variables = {
      GCP_PROJECT_ID  = "aispipeline"
      GCP_BUCKET_NAME = google_storage_bucket.ais_bronze_layer.name
      BQ_DATASET_ID   = google_bigquery_dataset.ais_gold_warehouse.dataset_id
      BQ_TABLE_ID     = google_bigquery_table.ais_obt.table_id
    }
  }
}
