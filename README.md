# Bitcoin Prices Scraper

This repository automates the daily collection and storage of Bitcoin price data using GitHub Actions and Amazon S3.

To view the Bitcoin prices, use the following [GUI](https://flatgithub.com/YangWu1227/flat-bitcoin-price).

## Features

- **Data Fetching**: Fetches Bitcoin prices daily from [CoinDesk API](https://api.coindesk.com/v2/bpi/currentprice.json).
- **Data Processing**: Converts raw JSON data into a structured format (`btc-price-postprocessed.json`).
- **Amazon S3 Integration**: Stores processed data in an AWS S3 bucket as partitioned parquet files ([hive-style](https://delta.io/blog/pros-cons-hive-style-partionining/)).

## Setup

- **Schedule**: Runs at 12:00 p.m. (noon) every day or on demand.
- **Technologies**: Deno runtime for postprocessing logic, Python Polars for data management logic, and Terraform for infrastructure setup.

### Terraform

* `terraform/s3`: Creates an S3 bucket for storing the scrapper data.

* `terraform/github_action`: Creates an IAM role for the GitHub Actions workflow, allowing get, put, and list operations on the s3 bucket created above.

    - `backend.hcl`: Configures the Terraform backend to store the state files in an S3 bucket (**created separately outside of this repository**).

## Credits

- Based on [Simon Willison's Git Scraping](https://simonwillison.net/2020/Oct/9/git-scraping/).
- Powered by [Flat Data GitHub Action](https://next.github.com/projects/flat-data/).
