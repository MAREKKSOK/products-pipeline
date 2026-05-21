# Products Pipeline

Simple Data Engineering project.

## What this project does

This project downloads product data, saves it to PostgreSQL and transforms data with dbt.

Pipeline:

API → PostgreSQL → dbt

## Technologies

- Python
- PostgreSQL
- dbt
- Git
- GitHub

## dbt models

- stg_products - cleaned product data
- mart_products - final business table

## Project status

The dbt part is working.

Next step:
- add Airflow pipeline