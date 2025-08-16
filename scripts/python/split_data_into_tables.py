import pandas as pd
import os

def split_data(input_path, output_dir, tables_columns):
    df = pd.read_csv(input_path)

    os.makedirs(output_dir, exist_ok=True)

    for table_name, columns in tables_columns.items():
        cols = [col for col in columns if col in df.columns]
        subset = df[cols].drop_duplicates()
        out_path = os.path.join(output_dir, f"{table_name}.csv")
        subset.to_csv(out_path, index=False)
        print(f"Saved {table_name} table to {out_path}")

if __name__ == "__main__":
    tables_columns = {
        'orders': ['order_id', 'customer_id', 'order_date', 'total_amount'],
        'products': ['product_id', 'product_name', 'price'],
        'customers': ['customer_id', 'customer_name', 'email'],
    }
    split_data(
        input_path='/opt/airflow/datasets/transformed_full/cleaned_data.csv',
        output_dir='/opt/airflow/datasets/transformed_tables',
        tables_columns=tables_columns
    )