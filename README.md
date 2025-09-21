# E-Commerce Project

This repository contains an end-to-end data engineering proof-of-concept for an e-commerce dataset (Olist Brazil). It includes raw CSV data, an extraction notebook, ETL SQL for loading raw tables, and a dbt project to build staging and marts models.

This README documents how to set up the environment, download the data, load raw data into Postgres, run dbt models, and where to find project artifacts.

## Repository layout

- `Data/` — raw dataset CSVs and helper SQL for loading raw schema:
	- `download_data.ipynb` — notebook to download and extract dataset files.
	- `create_raw_schema/` — SQL scripts to create raw schema and load data into Postgres (`create_raw_schema.sql`, `load_into_raw.sql`).
	- `olist_*_dataset.csv` — CSV files from the Olist Brazil dataset.
- `ETL/` — ETL scripts (currently empty placeholder).
- `ecommerce_dbt/` — dbt project that builds staging and marts models from raw tables.
	- `dbt_project.yml`, `models/staging/`, `models/marts/`, `seeds/`, `snapshots/`, `macros/`.
- `logs/` — project logs (dbt logs etc.).
- `download_data.ipynb` — top-level copy of the download notebook (also present in `Data/`).

## Quick start (assumptions)

Prerequisites:
- Python 3.8+ (recommended)
- Postgres (local or remote)
- dbt-core and dbt-postgres installed in your environment (see below)
- Kaggle credentials if using Kaggle APIs

Recommended: create a Python virtual environment, e.g.:

```bash
python -m venv .venv
source .venv/bin/activate
# If you have a requirements file, install it
# pip install -r requirements.txt
# Install dbt for Postgres
pip install "dbt-core==1.*" dbt-postgres
```

If you don't have a `requirements.txt`, install the Python packages you need (for notebook and kagglehub usage):

```bash
pip install pandas kagglehub
```

## Download and extract raw data

Open and run `download_data.ipynb` (the first cell now downloads the Olist dataset with `kagglehub.dataset_download()` and automatically extracts or copies files into the notebook working directory). Steps:

1. Ensure your Kaggle credentials are configured for `kagglehub` (or adjust the notebook to use your preferred download method).
2. Open the notebook and run the first cell. It will:
	 - Print the path(s) returned by `kagglehub.dataset_download()`.
	 - For each returned path, extract archives (zip/tar), copy single files, or copy directory contents into the current working directory.
3. The CSV files should appear in `Data/` (or the current working directory where you run the notebook).

If you prefer manual download, place the CSV files into `Data/` and ensure filenames match those referenced in `create_raw_schema/load_into_raw.sql`.

## Load raw CSVs into Postgres

1. Create a Postgres database, e.g. `ecommerce_project`.

```bash
# run in your shell (macOS zsh example)
psql -U postgres -c "CREATE DATABASE ecommerce_project;"
psql -U postgres -d ecommerce_project -f Data/create_raw_schema/create_raw_schema.sql
psql -U postgres -d ecommerce_project -f Data/create_raw_schema/load_into_raw.sql
```

2. The `create_raw_schema.sql` creates raw tables; `load_into_raw.sql` contains COPY or INSERT statements that expect the CSV files to be accessible to Postgres (local file paths) or you can use psql's `\\copy` to upload from your client machine.

Notes:
- If Postgres is running in a container, mount the `Data/` path into the container or use client-side `\\copy`.

## dbt project

Project path: `ecommerce_dbt/`

1. Configure your dbt profile (`~/.dbt/profiles.yml`) to point to your Postgres database. Example profile snippet:

```yaml
your_profile_name:
	target: dev
	outputs:
		dev:
			type: postgres
			host: localhost
			user: postgres
			password: <your_password>
			port: 5432
			dbname: ecommerce_project
			schema: analytics  # change to your chosen schema
```

2. From the `ecommerce_dbt/` folder (or project root), run:

```bash
# run the staging models only
cd ecommerce_dbt
dbt run --models staging/
# run all models
# dbt run
# run tests (if configured)
dbt test
```

3. The dbt project contains:
- `models/staging/` — staging models (stg_*.sql) which transform the raw CSV tables
- `models/marts/` — dimensional & fact models (dim_*, fact_*)
- `seeds/` — seed data (currently empty)

## Running locally (suggested order)

1. Set up Postgres and create the `ecommerce_project` database.
2. Download raw CSVs into `Data/` (run `download_data.ipynb` or copy files manually).
3. Run `create_raw_schema.sql` and `load_into_raw.sql` to load CSVs into raw tables.
4. Configure `~/.dbt/profiles.yml` and run `dbt run` from `ecommerce_dbt/`.

## Troubleshooting
- If dbt can't connect: verify `profiles.yml` credentials and network access to Postgres.
- If CSV loads fail: ensure file paths are accessible to Postgres server or use `\\copy` to upload from client.
- If you see Python errors in the notebook: ensure required packages are installed and Python version is 3.8+.

## Suggestions / Next steps
- Add a `requirements.txt` or `pyproject.toml` to pin Python dependencies.
- Add `Makefile` or a `scripts/` folder with convenience scripts for: creating DB, loading CSVs, and running dbt.
- Add a CI workflow (GitHub Actions) to run dbt tests on PRs.
- Add documentation for the data schema and model lineage (dbt docs site can be generated with `dbt docs generate` and `dbt docs serve`).

## Contact / License
Add licensing and contact information as appropriate for your project.

loadto postrgre:  psql -U postgres -d ecommerce_project -f create_schema.sql


edit:
code ~/.dbt/profiles.yml


dbt run --models staging/

one unique identifier of a customer can be assigned to many customer_id