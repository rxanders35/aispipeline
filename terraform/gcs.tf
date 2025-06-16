resource "google_storage_bucket" "ais_bronze_layer" {
  name                        = "ais_bronze_layer_01"
  location                    = "us-east1"
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type          = "SetStorageClass"
      storage_class = "ARCHIVE"
    }
  }
}

resource "google_storage_bucket_object" "source_archive_object" {
  name   = "source-code.zip"
  bucket = google_storage_bucket.ais_bronze_layer.name
  source = data.archive_file.source_zip.output_path
}
