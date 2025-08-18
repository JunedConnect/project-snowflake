USE WAREHOUSE "my-warehouse";
USE DATABASE "my-database";
USE SCHEMA "my-schema";

CREATE OR REPLACE TABLE orders (
    order_id STRING,
    customer_id STRING,
    order_date DATE,
    total_amount FLOAT
);

CREATE OR REPLACE TABLE products (
    product_id STRING,
    product_name STRING,
    price FLOAT
);

CREATE OR REPLACE TABLE customers (
    customer_id STRING,
    customer_name STRING,
    email STRING
);

COPY INTO orders
FROM @"my-stage"/orders.csv
FILE_FORMAT = (
    TYPE = 'CSV',
    FIELD_OPTIONALLY_ENCLOSED_BY = '"',
    SKIP_HEADER = 1
);

COPY INTO products
FROM @"my-stage"/products.csv
FILE_FORMAT = (
    TYPE = 'CSV',
    FIELD_OPTIONALLY_ENCLOSED_BY = '"',
    SKIP_HEADER = 1
);

COPY INTO customers
FROM @"my-stage"/customers.csv
FILE_FORMAT = (
    TYPE = 'CSV',
    FIELD_OPTIONALLY_ENCLOSED_BY = '"',
    SKIP_HEADER = 1
);