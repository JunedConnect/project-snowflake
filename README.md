# TransformOps


A deployment of workflow management tool (Apache Airflow) that will automate an ETL pipeline:

- Extraction and Transformation of raw CSV data into structured data
    Transformation pipeline includes:
    - **Clean**: remove empty rows, strip whitespace, drop duplicates, handle missing values
    - **Validate**: enforce required fields, check email formats, verify dates and numeric ranges
    - **Normalise**: standardise text formatting, map categorical values, derive calculated fields
    - **Partition**: split data into logical tables for efficient querying
- Upload of transformed data to a secured data-lake (AWS S3 Bucket)
- Load data from data-lake into a Snowflake Database and processing by a Data Warehouse into structured tables

<br>

Terraform is used to provision all pieces of the infrastructure:

- Modules and variable-driven configuration to follow the DRY principle
- Tightly scoped IAM policies for secure access control
- S3 buckets configured with security and redundancy in mind:
    - Server-side encryption with AES256 to protect data-at-rest
    - Versioning enabled for recovery against accidental deletes or overwrites
    - Strict public access blocking to prevent unauthorised access
    - Cross-bucket replication to a backup bucket with intelligent tiering for redundancy
    - Audit logging stored in a dedicated bucket for traceability
    - Daily inventory reports for visibility into stored objects and compliance

<br>

## Architecture Diagram:

![AD](https://raw.githubusercontent.com/JunedConnect/project-snowflake/main/images/architecture-diagram.png)

<br>

## Directory Structure:
```
./
├── airflow/
├── assets/
│   └── datasets/
├── images/
├── scripts/
│   ├── python/
│   └── sql/
├── terraform/
│   └── modules/
│         ├── iam/
│         ├── s3/
│         └── snowflake/
├── docker-compose.yml
└── Makefile
```

- `airflow/` - contains all Airflow specific files (DAGs, config and any custom plugins)
- `assets/` - stores datasets used by the pipeline i.e raw CSV and the transformed outputs
- `scripts/` - contains scripts used by the ETL pipeline (Python scripts and SQL queries)
- `terraform/` - includes all Terraform code to provision AWS and Snowflake resources
- `docker-compose.yml` - defines the Docker services needed to run the project locally
- `Makefile` - provides command shortcuts for Docker

<br>

<br>

## Local Set-Up


### Prerequisite

Before you start, make sure you have the following installed on your machine:

- **Terraform** (Version 1.12.2 and above)
- **Docker** (Version 27.5.1 and above)
- **AWS CLI** (Version 2 and above)
- **AWS account with admin access** (to avoid any issues relating to permissions)
- **Snowflake account**

<br>

If you do not have a Snowflake account:

1. Go to Snowflake's offical website account setup page.
2. Complete the registration process.
3. Log in and go to **Account Details** to view your **credentials** (You will need these for `.env` and `terraform.tfvars`).

<br>

---

### 1. Create the config files

```bash
cp .env.example .env
cp terraform/terraform.tfvars.example terraform/terraform.tfvars
```

<br>

---

### 2. Set up Variables

<br>

### Step A - Fill in `.env`

Replace the `[provide value here]` placeholder in `.env` with your Snowflake / AWS credentials:

| Variable | What to enter |
| --- | --- |
| `SNOWFLAKE_USER` | Your Snowflake username |
| `SNOWFLAKE_PASSWORD` | Your Snowflake password |
| `SNOWFLAKE_ACCOUNT` | Your Snowflake account identifier |
| `SNOWFLAKE_ROLE` | Your Snowflake role used by **Airflow** (e.g. `ACCOUNTADMIN`) |
| `AWS_ACCESS_KEY_ID` | AWS access key ID |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key |

Leave every other variable unchanged.

<br>

### Step B - Fill in `terraform.tfvars`

Replace the `[provide value here]` placeholder with your Snowflake credentials:

| Variable | What to enter |
| --- | --- |
| `snowflake-organization-name` | Your Snowflake organisation name |
| `snowflake-account-name` | Your Snowflake account name |
| `snowflake-user` | Your Snowflake username |
| `snowflake-password` | Your Snowflake password |
| `snowflake-role` | Your Snowflake role used by **Terraform** (e.g. `ACCOUNTADMIN`) |
| `snowflake-external-id` | You can enter any random string here |
| ❗ `snowflake-aws-account-id` ❗ | Your Snowflake AWS account ID |

<br>

❗ Important ❗:

The IAM role used by Snowflake requires the **Snowflake AWS account ID**, but you will not know this until after the first `terraform apply`. For now, place your own AWS account ID as a placeholder. This will be covered in **Step 4.**

<br>

Leave every other variable unchanged.

<br>

---

### 3. Start Airflow

Run:
```bash
make airflow-start
```

You can use the following commands if needed:

| Command | Description |
| --- | --- |
| `make airflow-logs` | View the Airflow Container  logs |
| `make airflow-stop` | Stop containers (keeps volumes and images) |
| `make airflow-remove` | Remove containers, volumes, and images |
| `make airflow-restart-soft` | Restart Airflow (keep volumes/images) |
| `make airflow-restart-hard` | Full rebuild (remove volumes/images and start fresh) |

<br>

---

### 4. Deploy the infrastructure (two-step Terraform flow)

<br>

### Step A – First Run

1. As mentioned in **Step 2b**, make sure your `snowflake-aws-account-id`  is set to your **own AWS account ID** within `terraform.tfvars`.
2. Run:

```bash
cd terraform
terraform init
terraform apply
```

Terraform will now set up the infrastructure.

Terraform will also output the **Snowflake AWS account ID** in the terminal. **Copy that Snowflake AWS account ID value.**

<br>

### Step B –  Second Run

1. Open `terraform.tfvars` and paste the value that you had copied:

```hcl
snowflake-aws-account-id = [provide value here]
```

2. Run Terraform again:

```bash
terraform apply
```

Terraform will now update the IAM role with the correct Snowflake account ID.

<br>

---

### 6. Trigger the Airflow DAG

1. Visit `http://localhost:8080`
2. Log in:
    - Default Username = airflow
    - Default Password = airflow
3. Enable **`my_final_dag`**

The DAG will then automatically run to:

- Transform the raw data file within `assets/datasets`
- Upload to the S3 data bucket
- Load into Snowflake

<br>

---

### 7. View data in Snowflake

Once the DAG has run successfully, you can create a new worksheet in Snowflake and run the following queries to check the tables:

```sql
-- Read first 100 orders
SELECT * FROM "my-database"."my-schema".orders
LIMIT 100;

-- Read first 100 products
SELECT * FROM "my-database"."my-schema".products
LIMIT 100;

-- Read first 100 customers
SELECT * FROM "my-database"."my-schema".customers
LIMIT 100;
```

These queries will allow you to verify that the data has been loaded successfully into Snowflake.

<br>

---

### 8. Teardown infrastructure

Once you are done and want to clean up everything:

```bash
#empty all S3 buckets:
aws s3 rm s3://<your-bucket-name> --recursive

#destroy Terraform-managed infrastructure
cd terraform
terraform destroy

#stop and remove Airflow containers, volumes, and images
make airflow-remove
```

This ensures both your cloud resources and local containers are fully cleaned up.

<br>

## Future Improvements:


- Implement incremental loading
- Create monitoring and alerting
- Add data lineage tracking
- Build a simple dashboard