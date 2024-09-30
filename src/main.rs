use arrow::csv::ReaderBuilder;
use arrow::record_batch::RecordBatch;
use parquet::arrow::ArrowWriter;
use reqwest;
use core::arch;
use std::fs;
use std::fs::File;
use std::fs::create_dir;
use std::io::{Cursor, Write};
use std::path::Path;
use std::sync::Arc;
use zip::read::ZipArchive;
use std::error::Error;

#[tokio::main]
async fn main() { 
    let url = "http://web.ais.dk/aisdata/aisdk-2024-09-26.zip";
    let zip_data = download_zip(url).await.unwrap();

    
}

async fn download_zip(url: &str) -> Result<Vec<u8>, Box<dyn Error>> {
    let response = reqwest::get(url).await?;
    let bytes = response.bytes().await?;
    Ok(bytes.to_vec())
}

fn unpack_zip(zip_data: Vec<u8>) -> Result<Vec<String>, Box<dyn Error>> {
    let path = "/medallion/bronze"; 
    
    let mut archive = ZipArchive::new(Cursor::new(zip_data))?;
    let csv_files = Vec::new();
    
    for i in 0..archive.len() {
        let mut file = archive.by_index(i)?;
        if file.name().ends_with(".csv") {
            csv_files.push(path.clone());
        }
    }
}