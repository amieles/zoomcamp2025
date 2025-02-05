CREATE OR REPLACE EXTERNAL TABLE `terraform-demo-447802.de_zoomcamp_447802.external_yellow_tripdata`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://test_bucket_yellow_2024/yellow_tripdata_2024-*.parquet']
);

SELECT * FROM `terraform-demo-447802.de_zoomcamp_447802.external_yellow_tripdata` limit 10;

CREATE OR REPLACE TABLE `terraform-demo-447802.de_zoomcamp_447802.yellow_tripdata_non_partitoned_2024` AS
SELECT * FROM `terraform-demo-447802.de_zoomcamp_447802.external_yellow_tripdata`;
--Q1
select count(*) from `terraform-demo-447802.de_zoomcamp_447802.yellow_tripdata_non_partitoned_2024`;
--Answer: 20,332,093


--Q2
select count(distinct PULocationID) from `terraform-demo-447802.de_zoomcamp_447802.yellow_tripdata_non_partitoned_2024`;

select count(distinct PULocationID) from `terraform-demo-447802.de_zoomcamp_447802.external_yellow_tripdata`;
--Answer: 0 MB for the External Table and 155.12 MB for the Materialized Table

--Q3
select PULocationID from `terraform-demo-447802.de_zoomcamp_447802.yellow_tripdata_non_partitoned_2024`;

select PULocationID, DOLocationID from `terraform-demo-447802.de_zoomcamp_447802.yellow_tripdata_non_partitoned_2024`;
--Answer: BigQuery is a columnar database, and it only scans the specific columns requested in the query. Querying two columns (PULocationID, DOLocationID) requires reading more data than querying one column (PULocationID), leading to a higher estimated number of bytes processed.

--Q4
select count(*) from `terraform-demo-447802.de_zoomcamp_447802.yellow_tripdata_non_partitoned_2024` where fare_amount = 0; 
--Answer: 8333

--Q5
CREATE OR REPLACE TABLE `terraform-demo-447802.de_zoomcamp_447802.yellow_tripdata_partitoned_2024`
PARTITION BY DATE(tpep_pickup_datetime)
CLUSTER BY VendorID AS
SELECT * FROM `terraform-demo-447802.de_zoomcamp_447802.yellow_tripdata_non_partitoned_2024`;
--Answer: Partition by tpep_dropoff_datetime and Cluster on VendorID

--Q6
select distinct VendorID from `terraform-demo-447802.de_zoomcamp_447802.yellow_tripdata_non_partitoned_2024`
where tpep_dropoff_datetime >= '2024-01-03' and tpep_dropoff_datetime <= '2024-01-15';
--310MB

select distinct VendorID from `terraform-demo-447802.de_zoomcamp_447802.yellow_tripdata_partitoned_2024`
where tpep_dropoff_datetime >= '2024-01-03' and tpep_dropoff_datetime <= '2024-01-15';
--18.39MB
--Answer: 310.24 MB for non-partitioned table and 26.84 MB for the partitioned table

--Q7
--Answer:GCP Bucket

--Q8
-- Answer: False
--Bonus: 0 bytes, result is cached
select count(*) from `terraform-demo-447802.de_zoomcamp_447802.yellow_tripdata_partitoned_2024`;