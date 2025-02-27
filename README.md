# Bitcoin Prices Scraper

This repository automates the daily collection and storage of Bitcoin price data using GitHub Actions and Amazon S3.

To view the Bitcoin prices, use the following [GUI](https://flatgithub.com/yangwu1227/bitcoin-prices-scraper).

## Features

- **Data Fetching**: Fetches Bitcoin prices daily from [Coingecko API](https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=usd,gbp,eur,cny).
- **Data Processing**: Converts raw JSON data into a structured format (`btc-price-postprocessed.json`).
- **Amazon S3 Integration**: Stores processed data in an S3 bucket as partitioned parquet files ([hive-style](https://delta.io/blog/pros-cons-hive-style-partionining/)).

## Setup

- **Schedule**: Runs at 12:00 p.m. UTC every day or on demand.
- **Technologies**: Deno runtime for postprocessing logic, Python Polars for data management logic, and Terraform for infrastructure setup.

### Terraform

- `terraform/modules`: Contains reusable Terraform modules shared by both `s3/dev` and `s3/prod`.

- `terraform/s3`: Creates an S3 bucket for storing the API scraped data.

  - `terraform/s3/dev`: Creates a development environment with an S3 bucket suffixed with `-dev`.
  - `terraform/s3/prod`: Creates a production environment with an S3 bucket suffixed with `-prod`.

- `terraform/github_action`: Creates an IAM role for the GitHub Actions workflow, allowing get, put, and list operations on the s3 buckets created above.

- `backend.hcl` or `backend-*.hcl`: Defines the Terraform backend configuration to store state files in an **S3 bucket managed separately from this repository**. This separation ensures state files are not stored in the same bucket they track, maintaining clear boundaries between resource provisioning (e.g., S3 bucket, IAM roles/policies) and state management.

    ```markdown
    +--------------------------+                 +--------------------------+
    |    State Management      |                 |      Resource Buckets    |
    |        Bucket            |                 |                          |
    | +----------------------+ |                 | +----------------------+ |
    | | github_action/       | |                 | | S3 Bucket - dev      | |
    | | terraform.tfstate    | |                 | | (stores data)        | |
    | +----------------------+ |                 | +----------------------+ |
    | | s3/dev/              | |                 | +----------------------+ |
    | | terraform.tfstate    | |                 | | S3 Bucket - prod     | |
    | +----------------------+ |                 | | (stores data)        | |
    | | s3/prod/             | |                 | +----------------------+ |
    | | terraform.tfstate    | |                 |                          |
    | +----------------------+ |                 |                          |
    +--------------------------+                 +--------------------------+
    ```

## Credits

- Based on [Simon Willison's Git Scraping](https://simonwillison.net/2020/Oct/9/git-scraping/).
- Powered by [Flat Data GitHub Action](https://next.github.com/projects/flat-data/).
