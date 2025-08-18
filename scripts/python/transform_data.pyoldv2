import pandas as pd

def transform_data(input_path, output_path, required_columns=None, date_columns=None):
    df = pd.read_csv(input_path)

    df = df.dropna(how='all')

    if required_columns:
        df = df.dropna(subset=required_columns)

    for col in df.select_dtypes(include=['object']).columns:
        df[col] = df[col].str.strip()

    if date_columns:
        for dcol in date_columns:
            df[dcol] = pd.to_datetime(df[dcol], errors='coerce')
        df = df.dropna(subset=date_columns)

    expected_cols = len(df.columns)
    df = df[df.apply(lambda x: x.count(), axis=1) >= expected_cols - 1]

    df.to_csv(output_path, index=False)
    print(f"Cleaned data saved to {output_path}")

if __name__ == "__main__":
    transform_data(
        input_path='/opt/airflow/datasets/original_file/raw_data.csv',
        output_path='/opt/airflow/datasets/transformed_full/cleaned_data.csv',
        required_columns=['order_id', 'customer_id', 'email'],
        date_columns=['order_date']
    )