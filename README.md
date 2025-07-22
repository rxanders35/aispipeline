### GLOBAL AUTOMATIC IDENTIFICATION SYSTEM (AIS) DATA PLATFORM ###

The **goal** of this project is to build a data processing platform
that aggregates global Automatic Identification System (AIS) data
from various sources in order to produce a holistic picture
into global maritime trade.

**What is AIS?**
AIS is a system integrated into maritime vessels that communicates
with a satellite to continuously notify fellow vessels, radar systems,
ports, coast guards, and shipping companies about a given ship's name,
geographical coordinates, course, speed, payload, vessel dimensions,
and other pertinent metadata.

**Use Case**
Understanding AIS data, especially in particular bodies of water,
allows one to get snapshot into the economic and geopolitical
situation of a given region, as well as granular information
about the flow of goods, the actors involved, and potential
supply chain risks.

**Current Project Status**
Currently, this project is in its beginning stages. Right now, it is
employing the usage of a GCP Gen2 Cloud Function and Cloud Scheduler
to fetch raw CSV data from an official Danish Government AIS data
website: (http://web.ais.dk/aisdata/). The Cloud Scheduler runs a Cloud
Function job, which downloads the CSV file into a "bronze layer" GCS
staging environment, and then loads the file into a BigQuery table.

**Short-Term Goals**
- Build an API that serves the data for a React frontend, which itself will
  display the ships on a map, with a slider to see historical data.
- Reserialize the existing CSV data into Parquet for more cost-effective
  storage and query performance
**Long-Term Goals**
- Locate other sources of AIS data from other Baltic and North Sea countries.
- Build a Spark job in Databricks or GCP Dataproc Serverless which will
  synthesize and transform the disparate sources into a single Baltic/North
  Sea table, providing a *complete* view into regional vessel traffic over
  time.
