terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

provider "google" {
  project = "aispipeline"
  region  = "us-east1"
}

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

resource "google_bigquery_dataset" "ais_gold_warehouse" {
  dataset_id                 = "ais_gold_warehouse_01"
  friendly_name              = "AIS Gold Layer Data Warehouse"
  location                   = "us-east1"
  delete_contents_on_destroy = true
}

resource "google_bigquery_table" "ais_obt" {
  project    = "aispipeline"
  dataset_id = google_bigquery_dataset.ais_gold_warehouse.dataset_id
  table_id   = "ships_2025"
  schema = jsonencode([
    { "name" : "timestamp", "type" : "TIMESTAMP" },
    { "name" : "type_of_mobile", "type" : "STRING" },
    { "name" : "mmsi", "type" : "INTEGER" },
    { "name" : "latitude", "type" : "FLOAT" },
    { "name" : "longitude", "type" : "FLOAT" },
    { "name" : "navigational_status", "type" : "STRING" },
    { "name" : "rot", "type" : "FLOAT" },
    { "name" : "sog", "type" : "FLOAT" },
    { "name" : "cog", "type" : "FLOAT" },
    { "name" : "heading", "type" : "FLOAT" },
    { "name" : "imo", "type" : "INTEGER" },
    { "name" : "callsign", "type" : "STRING" },
    { "name" : "name", "type" : "STRING" },
    { "name" : "ship_type", "type" : "STRING" },
    { "name" : "cargo_type", "type" : "STRING" },
    { "name" : "width", "type" : "FLOAT" },
    { "name" : "length", "type" : "FLOAT" },
    { "name" : "type_of_position_fixing_device", "type" : "STRING" },
    { "name" : "draught", "type" : "FLOAT" },
    { "name" : "destination", "type" : "STRING" },
    { "name" : "eta", "type" : "STRING" },
    { "name" : "data_source_type", "type" : "STRING" },
    { "name" : "size_a", "type" : "FLOAT" },
    { "name" : "size_b", "type" : "FLOAT" },
    { "name" : "size_c", "type" : "FLOAT" },
    { "name" : "size_d", "type" : "FLOAT" }
  ])
  time_partitioning {
    type  = "DAY"
    field = "Timestamp"
  }
  clustering = ["MMSI"]
}
