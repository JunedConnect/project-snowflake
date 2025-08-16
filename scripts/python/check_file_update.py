import os
from airflow.sdk import Variable
from airflow.exceptions import AirflowSkipException

FILE_PATH = '/opt/airflow/datasets/original_file/raw_data.csv'
LAST_MOD_VAR = 'raw_data_last_modified'

def check_file_update(**context):
    if not os.path.exists(FILE_PATH):
        raise FileNotFoundError(f"{FILE_PATH} not found")

    current_modified = os.path.getmtime(FILE_PATH)

    prev_modified = None
    try:
        prev_modified = float(Variable.get(LAST_MOD_VAR))
    except Exception:
        print("Variable not found. This is the first run.")

    Variable.set(LAST_MOD_VAR, str(current_modified))

    if prev_modified is None:
        print("First check: recording modification time.")
    elif current_modified != prev_modified:
        print("File has been updated.")
    else:
        print("No change detected in the file.")
        raise AirflowSkipException("No update detected")