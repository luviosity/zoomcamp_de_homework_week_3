-- Creating an external table using the Green Taxi Trip Records Data for 2022.
create or replace external table `terraform-demo-412521.ny_taxi.green_taxi_trip_data_2022_external`
OPTIONS (
  format = 'parquet',
  uris = ['gs://mage-demo-bucket-andreev/green_tripdata_2022-*.parquet']
)
;

-- Creating an unpartioned and unclustered table in BQ using the Green Taxi Trip Records for 2022.
create or replace table `terraform-demo-412521.ny_taxi.green_taxi_trip_data_2022` as
select * from `terraform-demo-412521.ny_taxi.green_taxi_trip_data_2022_external`
;

/* Question 1:
    What is count of records for the 2022 Green Taxi Data?

    TIP: It's better to see this information in the DETAILS tab because it's free and there are no charges for querying the data.
*/
select count(*)
from `terraform-demo-412521.ny_taxi.green_taxi_trip_data_2022`
;

/* Question 2:
    Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.
    What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?
*/
select count(distinct PULocationID)
from `terraform-demo-412521.ny_taxi.green_taxi_trip_data_2022` -- `terraform-demo-412521.ny_taxi.green_taxi_trip_data_2022_external`
;

-- Question 3: How many records have a fare_amount of 0?
select count(1) as cnt
from `terraform-demo-412521.ny_taxi.green_taxi_trip_data_2022`
where fare_amount = 0
;

/*  Question 4:
    What is the best strategy to make an optimized table in Big Query if your query will always order the results by
    PUlocationID and filter based on lpep_pickup_datetime? (Create a new table with this strategy)
*/
create or replace table `terraform-demo-412521.ny_taxi.green_taxi_trip_data_2022_partitioned_and_clustered`
partition by date(lpep_pickup_datetime)
cluster by PUlocationID as
select * from `terraform-demo-412521.ny_taxi.green_taxi_trip_data_2022`
;

/* Question 5:
    Write a query to retrieve the distinct PULocationID between lpep_pickup_datetime 06/01/2022 and 06/30/2022 (inclusive).

    Use the materialized table you created earlier in your from clause and note the estimated bytes.
    Now change the table in the from clause to the partitioned table you created for question 4 and note the estimated bytes processed.
    What are these values?
*/
select count(distinct PULocationID)
from `terraform-demo-412521.ny_taxi.green_taxi_trip_data_2022` -- `terraform-demo-412521.ny_taxi.green_taxi_trip_data_2022_partitioned_and_clustered`
where lpep_pickup_datetime between '2022-06-01' and '2022-06-30'
;