import pandas as pd
import re

def validate_email(email):
    pattern = r'^[\w\.-]+@[\w\.-]+\.\w+$'
    return bool(re.match(pattern, str(email)))

def transform_data(
    input_path, 
    output_path, 
    required_columns=None, 
    date_columns=None, 
    numeric_columns=None, 
    categorical_columns=None, 
    derived_columns=None,
    max_missing_ratio=0.2
):
    df = pd.read_csv(input_path, dtype=str)
    original_count = len(df)
    
    # Clean: remove empty rows, strip whitespace
    df = df.dropna(how='all')
    df = df.applymap(lambda x: x.strip() if isinstance(x, str) else x)
    
    # Validate: required columns
    if required_columns:
        df = df.dropna(subset=required_columns)
    
    # Validate: email
    if 'email' in df.columns:
        df = df[df['email'].apply(validate_email)]
    
    # Normalise: text
    for col in df.select_dtypes(include=['object']).columns:
        df[col] = df[col].str.title().str.replace(r'\s+', ' ', regex=True)
    
    # Type cast: dates
    if date_columns:
        for dcol in date_columns:
            if dcol in df.columns:
                df[dcol] = pd.to_datetime(df[dcol], errors='coerce')
        df = df.dropna(subset=[c for c in date_columns if c in df.columns])
    
    # Validate: numeric ranges
    if numeric_columns:
        for ncol, (min_val, max_val) in numeric_columns.items():
            if ncol in df.columns:
                df[ncol] = pd.to_numeric(df[ncol], errors='coerce')
                df[ncol] = df[ncol].clip(lower=min_val, upper=max_val)
    
    # Normalise: categorical
    if categorical_columns:
        for ccol, mapping in categorical_columns.items():
            if ccol in df.columns:
                df[ccol] = df[ccol].map(mapping).fillna(df[ccol])
    
    # Derived calculations
    if derived_columns:
        for new_col, formula in derived_columns.items():
            df[new_col] = df.eval(formula)
    
    # Remove duplicates
    df = df.drop_duplicates()
    
    # Prune rows with too many missing values
    allowed_missing = int(len(df.columns) * max_missing_ratio)
    df = df[df.apply(lambda x: x.count() >= len(df.columns) - allowed_missing, axis=1)]
    
    removed_count = original_count - len(df)
    print(f"Rows removed during transformation: {removed_count}")
    
    df.to_csv(output_path, index=False)
    print(f"Transformed data saved to {output_path}")


if __name__ == "__main__":
    transform_data(
        input_path='/opt/airflow/datasets/original_file/raw_data.csv',
        output_path='/opt/airflow/datasets/transformed_full/cleaned_data.csv',
        required_columns=['order_id', 'customer_id', 'email'],
        date_columns=['order_date'],
        numeric_columns={'price': (0, 10000), 'quantity': (0, 1000), 'total_amount': (0, 100000)},
        categorical_columns={'product_name': {'Widget A': 'Widget A', 'Widget B': 'Widget B', 'Widget C': 'Widget C'}},
        derived_columns={'total_amount': 'price * quantity'},
        max_missing_ratio=0.2
    )