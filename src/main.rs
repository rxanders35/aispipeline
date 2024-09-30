use arrow::csv::ReaderBuilder;
use arrow::record_batch::RecordBatch;
use parquet::arrow::ArrowWriter;
use reqwest;
use std::fs::File;
use std::io::{Cursor, Write};
use std::path::Path;
use std::sync::Arc;
use zip::read::ZipArchive;

#[tokio::main]
async fn main() {

}

