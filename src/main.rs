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
    let bronze_zone = "/medallion/bronze";
    let silver_zone = "/medallion/silver";

    //let zip_data = download_zip(url).await.unwrap();
    //let zip_file_path = format("{}/aisdk-2024-09-26.zip", bronze_zone);
    //let csv_files = unpack_zip(zip_data, bronze_zone)?;
    
}

async fn download_zip(url: &str) -> Result<Vec<u8>, Box<dyn Error>> {
    let response = reqwest::get(url).await?;
    let bytes = response.bytes().await?;
    Ok(bytes.to_vec())
}

fn zip_to_bronze(zip_file_path: &str, zip_data: &[u8]) -> Result<(), Box<dyn Error>> {
    let mut file = File::create(zip_file_path)?;
    file.write_all(zip_data)?;
    Ok(())
}


fn unpack_zip(zip_data: Vec<u8>, bronze_zone: &str) -> Result<Vec<String>, Box<dyn Error>> {
    todo!("later")
}