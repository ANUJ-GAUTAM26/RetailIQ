import os
from datetime import datetime

from airflow import DAG
from airflow.providers.docker.operators.docker import DockerOperator


with DAG(
    dag_id="retailiq_pipeline",
    start_date=datetime(2026, 1, 1),
    schedule=None,
    catchup=False,
    tags=["retailiq", "etl"],
) as dag:

    run_etl = DockerOperator(
        task_id="run_retailiq_etl",

        image="retailiq-etl:latest",

        docker_url="unix://var/run/docker.sock",

        network_mode="retailiq_default",

        auto_remove="success",

        environment={
            "DB_USER": os.environ["DB_USER"],
            "DB_PASSWORD": os.environ["DB_PASSWORD"],
            "DB_NAME": os.environ["DB_NAME"],
            "DB_HOST": "postgres",
            "DB_PORT": "5432",
        },
    )