# Bitcoin Prices Scraper

This repository automates the daily collection and storage of Bitcoin price data using GitHub Actions and Amazon S3.

To view the Bitcoin prices, use the following [GUI](https://flatgithub.com/YangWu1227/flat-bitcoin-price).

## Features

- **Data Fetching**: Fetches Bitcoin prices daily from [CoinDesk API](https://api.coindesk.com/v2/bpi/currentprice.json).
- **Data Processing**: Converts raw JSON data into a structured format (`btc-price-postprocessed.json`).
- **Amazon S3 Integration**: Stores processed data in an AWS S3 bucket as partitioned parquet files ([hive-style](https://delta.io/blog/pros-cons-hive-style-partionining/)).

## Automation

- **Schedule**: Runs at 12:00 p.m. (noon) every day or on demand.
- **Technologies**: Deno runtime for postprocessing, Python Polars for data management, and Terraform for infrastructure setup.

## Credits

- Based on [Simon Willison's Git Scraping](https://simonwillison.net/2020/Oct/9/git-scraping/).
- Powered by [Flat Data GitHub Action](https://next.github.com/projects/flat-data/).
