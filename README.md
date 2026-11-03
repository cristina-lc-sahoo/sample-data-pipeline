# Automated AWS S3-to-Snowflake Data Pipeline

## Project Overview

This project demonstrates an automated cloud data ingestion pipeline that transfers CSV data stored in Amazon S3 into Snowflake using Snowpipe auto-ingest.

The pipeline uses AWS S3 event notifications and an SQS notification queue to notify Snowflake when new files are uploaded. Snowpipe processes these notifications and automatically loads new data into Snowflake tables, making the latest data available for SQL queries.

The project explores cloud storage integration, automated data ingestion, SQL-based data processing, and event-driven pipeline architecture.

## Architecture

GitHub
  |
  | CSV file upload / update
  v
AWS S3 Bucket
  |
  | S3 Object-Created Event
  v
Amazon SQS Queue
(Snowflake-managed)
  |
  | Notification
  v
Snowflake Snowpipe
  |
  | Automated COPY INTO
  v
Snowflake RAW_USERS Table
  |
  v
SQL Views / Data Queries


## Technologies Used

| Technology | Purpose |
|---|---|
| GitHub | Source file management and workflow automation |
| GitHub Actions | YAML-based workflow automation |
| Amazon S3 | Cloud storage for CSV files |
| AWS IAM | Access permissions and secure service integration |
| Amazon SQS | Notification delivery for Snowpipe auto-ingest |
| Snowflake | Cloud data warehouse |
| Snowpipe | Automated file ingestion |
| Snowflake SQL | Database setup, staging, loading, and data processing |

## Project Implementation

### 1. GitHub Workflow Automation

Created a YAML-based GitHub Actions workflow to automate the transfer of updated CSV files from GitHub to an Amazon S3 bucket.

### 2. AWS S3 Storage

Configured an S3 bucket to store incoming CSV files.

Example project file location:

s3://cristina-data-pipeline-bucket-2026/data/


### 3. Snowflake Database and Table Setup

Used Snowflake SQL to create the database environment, schemas, and destination tables for incoming data.

Example table structure:

sql
CREATE OR REPLACE TABLE raw_users (
    id INT,
    name STRING,
    email STRING,
    signup_date DATE
);


### 4. External Stage and File Format

Configured a Snowflake external stage to reference CSV files stored in Amazon S3.

Created a CSV file format to handle headers, quoted fields, date values, and empty fields.

### 5. Snowpipe Auto-Ingest

Created a Snowpipe using `AUTO_INGEST = TRUE` to automatically load new files when S3 event notifications are received through the Snowflake-managed SQS queue.

Example:

CREATE OR REPLACE PIPE users_pipe
AUTO_INGEST = TRUE
AS
COPY INTO users_raw
FROM @users_stage
FILE_FORMAT = (TYPE = CSV SKIP_HEADER = 1);


### 6. Data Validation and Monitoring

Used Snowflake SQL to monitor ingestion activity and validate loaded records.

Examples include:

-- Check Snowpipe status
SELECT SYSTEM$PIPE_STATUS('users_pipe');

-- Review loaded records
SELECT * FROM users_raw;

-- Review recent file load history
SELECT *
FROM TABLE(INFORMATION_SCHEMA.COPY_HISTORY(
    TABLE_NAME => 'USERS_RAW',
    START_TIME => DATEADD(hours, -1, CURRENT_TIMESTAMP())
));


### 7. Data Cleanup and Querying

Created SQL views to support deduplication and provide a cleaner representation of the loaded data.

Used `SELECT DISTINCT` and file metadata to explore data quality and identify the latest ingested files.

## Key Skills Demonstrated

- AWS S3 cloud storage configuration
- AWS IAM access permissions
- GitHub Actions and YAML workflow automation
- Snowflake database and SQL development
- External stages and CSV file formats
- Snowpipe automated ingestion
- S3 event notifications and SQS integration
- SQL-based data validation and transformation
- Pipeline monitoring and troubleshooting

## Project Goals and Learning Outcomes

This project provided hands-on experience building an AWS-to-Snowflake data pipeline and extending traditional file loading into an event-driven ingestion architecture.

It demonstrates how cloud storage, event notifications, and Snowflake automation can work together to make data available for analytics with minimal manual intervention.

## Security Considerations

- Never commit AWS access keys, secret keys, passwords, or other credentials to GitHub.
- Use secure credential management for GitHub Actions.
- Use Snowflake storage integrations and AWS IAM roles for secure access where configured.
- Restrict AWS permissions to the resources required by the pipeline.
