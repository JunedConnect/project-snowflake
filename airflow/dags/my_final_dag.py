from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta
import subprocess
import sys

sys.path.append('/opt/airflow/scripts/python')
from check_file_update import check_file_update

def run_script(script_name, **kwargs):
    script_path = f'/opt/airflow/scripts/python/{script_name}'
    result = subprocess.run(['python3', script_path], capture_output=True, text=True)
    if result.returncode != 0:
        raise Exception(f"Script {script_name} failed:\n{result.stderr}")
    print(result.stdout)

default_args = {
    'retries': 1,
    'retry_delay': timedelta(minutes=1)
}

with DAG(
    dag_id='my_final_dag',
    start_date=datetime(2025, 1, 1),
    schedule='*/1 * * * *',
    catchup=False,
    default_args=default_args,
) as dag:

    check_file_task = PythonOperator(
        task_id='check_file_update',
        python_callable=check_file_update,
    )

    transform_task = PythonOperator(
        task_id='transform_data',
        python_callable=run_script,
        op_args=['transform_data.py'],
    )

    split_task = PythonOperator(
        task_id='split_data',
        python_callable=run_script,
        op_args=['split_data_into_tables.py'],
    )

    upload_task = PythonOperator(
        task_id='upload_to_s3',
        python_callable=run_script,
        op_args=['upload_data_to_s3_bucket.py'],
    )

    load_snowflake_task = PythonOperator(
        task_id='load_into_snowflake',
        python_callable=run_script,
        op_args=['load_into_snowflake.py'],
    )

    check_file_task >> transform_task >> split_task >> upload_task >> load_snowflake_task