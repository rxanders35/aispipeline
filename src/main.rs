use arrow::csv::ReaderBuilder;
use arrow::record_batch::RecordBatch;
use parquet::arrow::ArrowWriter;
use reqwest;
use std::fs::File;
use std::io::{Cursor, Write};
use std::path::Path;
use std::sync::Arc;
use zip::read::ZipArchive;
use std::error::Error;

#[tokio::main]
async fn main() {

}

async fn download_zip(url: &str) -> Result<Vec<u8>, Box<dyn Error>> {
    let response = reqwest::get(url).await?;
    let bytes = response.bytes().await?;
    Ok(bytes.to_vec())
}

async fn unpack_zip(){

}

async fn unpack_zip(){
    todo!();
}