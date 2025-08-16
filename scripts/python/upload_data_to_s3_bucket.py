import boto3
import os

def upload_files_to_s3(bucket_name, base_path, files):
    s3 = boto3.client('s3')
    for file_name in files:
        local_path = os.path.join(base_path, file_name)
        if os.path.exists(local_path):
            s3.upload_file(local_path, bucket_name, file_name)
            print(f"Uploaded {file_name} to s3://{bucket_name}/{file_name}")
        else:
            print(f"File {local_path} does not exist, skipping.")

if __name__ == "__main__":
    bucket_name = os.getenv('S3_BUCKET_NAME')
    base_path = '/opt/airflow/datasets/transformed_tables'
    files = ['orders.csv', 'products.csv', 'customers.csv']

    if not bucket_name:
        raise ValueError("S3_BUCKET_NAME environment variable is not set")

    upload_files_to_s3(bucket_name, base_path, files)