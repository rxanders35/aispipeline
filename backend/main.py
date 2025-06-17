import traceback
import requests
import json
import datetime
import time
import os
from dotenv import load_dotenv
from google.cloud import storage
from google.cloud import bigquery

def process_ais_csvs(event, context):
    PROJECT_ID = os.environ.get("GCP_PROJECT_ID")
    BUCKET_NAME = os.environ.get("GCP_BUCKET_NAME")
    DATASET_ID = os.environ.get("BQ_DATASET_ID")
    TABLE_ID = os.environ.get("BQ_TABLE_ID")

    if not all([PROJECT_ID, BUCKET_NAME, DATASET_ID, TABLE_ID]):
        raise ValueError("Not all environment vars have been set")


    gcs_client = storage.Client()
    bq_client = bigquery.Client()

    try:
        yesterday = (datetime.date.today() - datetime.timedelta(days=3)).strftime('%Y-%m-%d')
        source_file_name = f"aisdk-{yesterday}.zip"
        url = f"https://web.ais.dk/aisdata/{source_file_name}"

        resp = requests.get(url, stream=True)
        resp.raise_for_status()

        start_time = time.monotonic()
        bucket = gcs_client.bucket(BUCKET_NAME)
        blob = bucket.blob(source_file_name)
        file_size = int(resp.headers.get('content-length', 0))
        chunks_downloaded = 0
        bytes_downloaded = 0

        with blob.open("wb") as writer:
            for chunk in resp.iter_content(chunk_size=8192):
                writer.write(chunk)
                chunks_downloaded += 1
                bytes_downloaded += len(chunk)
                if chunks_downloaded % 1000 == 0:
                    current_time = time.monotonic()
                    elapsed_seconds = str(datetime.timedelta(seconds=(current_time - start_time)))
                    fmt_time = elapsed_seconds.split('.')[0]
                    log_payload = {
                        "message": "File download in progress",
                        "severity": "INFO",
                        "progress": {
                            "chunks": chunks_downloaded,
                            "bytes": bytes_downloaded,
                            "total_bytes": file_size,
                        },
                        "performance": {
                            "elapsed_time": fmt_time
                        }
                    }
                    print(json.dumps(log_payload))
        
        gcs_upload_log = {
            "message": f"Successfully uploaded {source_file_name} to GCS.",
            "severity": "INFO",
            "file_size_bytes": file_size
        }
        print(json.dumps(gcs_upload_log))

        destination_table_id = f"{PROJECT_ID}.{DATASET_ID}.{TABLE_ID}"
        gcs_uri = f"gs://{BUCKET_NAME}/{source_file_name}"

        job_config = bigquery.LoadJobConfig(
            source_format=bigquery.SourceFormat.CSV,
            skip_leading_rows=1,
            autodetect=False,
        )

        load_job = bq_client.load_table_from_uri(
            gcs_uri,
            destination_table_id,
            job_config=job_config
        )

        load_job_log_payload = {
            "message": f"BigQuery load job started successfully for {source_file_name}",
            "severity": "INFO",
            "job_id": load_job.job_id
        }
        print(json.dumps(load_job_log_payload))

    except requests.exceptions.HTTPError as e:
        if e.response.status_code == 404:
            not_found_payload = {
                "message": f"Data file not found on source server for date: {yesterday}", # type: ignore
                "severity": "WARNING",
                "url_checked": url # type: ignore
            }
            print(json.dumps(not_found_payload))
        else:
            http_error_payload = {
                "message": "HTTP Error during download",
                "severity": "ERROR",
                "error_details": str(e),
                "stack_trace": traceback.format_exc()
            }
            print(json.dumps(http_error_payload))
            
    except Exception as e:
        error_payload = {
            "message": "An unexpected error occurred in the pipeline",
            "severity": "ERROR",
            "error_details": str(e),
            "stack_trace": traceback.format_exc()
        }
        print(json.dumps(error_payload))

def main():
    process_ais_csvs(None, None)
