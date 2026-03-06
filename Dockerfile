FROM apache/airflow:2.8.1

USER root
RUN apt-get update && apt-get install -y git && apt-get clean

USER airflow
RUN pip install --no-cache-dir \
    dbt-core==1.7.0 \
    dbt-duckdb==1.7.0 \
    duckdb==0.9.2