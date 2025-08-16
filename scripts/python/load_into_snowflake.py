import os
import snowflake.connector

user = os.getenv('SNOWFLAKE_USER')
password = os.getenv('SNOWFLAKE_PASSWORD')
account = os.getenv('SNOWFLAKE_ACCOUNT')
warehouse = os.getenv('SNOWFLAKE_WAREHOUSE')
database = os.getenv('SNOWFLAKE_DATABASE')
schema = os.getenv('SNOWFLAKE_SCHEMA')
role = os.getenv('SNOWFLAKE_ROLE')

conn = snowflake.connector.connect(
    user=user,
    password=password,
    account=account,
    warehouse=warehouse,
    database=database,
    schema=schema,
    role=role
)

cs = conn.cursor()

try:
    sql_file_path = '/opt/airflow/scripts/sql/load_into_snowflake.sql'

    with open(sql_file_path, 'r') as file:
        sql_commands = file.read()

    for command in sql_commands.strip().split(';'):
        if command.strip():
            cs.execute(command)
    conn.commit()
    print("Tables created and data loaded successfully.")

finally:
    cs.close()
    conn.close()