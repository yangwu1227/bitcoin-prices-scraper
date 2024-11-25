import json
import os
from datetime import datetime
from logging import Logger, StreamHandler, getLogger
from sys import stdout
from typing import Dict, List

import polars as pl
import pyarrow as pa
import pyarrow.dataset as ds

ENV: str = os.environ.get("ENV", "dev")
BITCOIN_FILE_NAME: str = "btc-price-postprocessed.json"
S3_BUCKET: str = f"bitcoin-prices-scraper-{ENV}"
S3_KEY: str = "bitcoin-prices"
logger: Logger = getLogger("write_data")
logger.setLevel("INFO")
logger.addHandler(StreamHandler(stdout))


def construct_data_frame() -> pl.DataFrame:
    """
    Construct a polars DataFrame from the JSON file.

    Returns
    -------
    pl.DataFrame
        A polars DataFrame with the columns `currency`,
        `bitcoin_rate`, and `date`.
    """
    with open(BITCOIN_FILE_NAME, "r") as f:
        json_data: List[Dict[str, str]] = json.load(f)
        logger.info(f"Read {len(json_data)} records from {BITCOIN_FILE_NAME}")
    data: pl.DataFrame = pl.from_dicts(data=json_data)
    # Sanitize data
    data: pl.DataFrame = data.with_columns(
        pl.lit(datetime.now().strftime("%Y-%m-%d")).alias("date")
    )
    data: pl.DataFrame = data.select(
        pl.col("currency").cast(pl.String).alias("currency"),
        pl.col("bitcoin_rate")
        .str.replace_all(",", "")
        .cast(pl.Float64)
        .alias("bitcoin_rate"),
        pl.col("date").cast(pl.Date).alias("date"),
    )
    return data


def write_to_s3(new_data: pl.DataFrame) -> None:
    """
    Write the DataFrame to an S3 bucket.

    Parameters
    ----------
    new_data : pl.DataFrame
        The new data to write to S3.

    Returns
    -------
    None
    """
    s3_uri: str = f"s3://{S3_BUCKET}/{S3_KEY}"

    existing_data: pl.DataFrame = pl.scan_parquet(
        f"{s3_uri}/*/*.parquet",
        hive_partitioning=True,
    ).collect()
    logger.info(f"Read in data with shape {existing_data.shape} from {s3_uri}")

    latest_date = (
        existing_data["date"].dt.max() if not existing_data.is_empty() else None
    )
    new_data_date = new_data["date"].dt.max()
    logger.info(f"Latest date in existing data: {latest_date}")
    logger.info(f"Latest date in new data: {new_data_date}")

    if latest_date == new_data_date:
        logger.info("Data is up-to-date; no new data appended")
        return None

    # Match the column orders
    new_data = new_data.select(existing_data.columns)
    updated_data: pl.DataFrame = pl.concat(
        items=[existing_data, new_data],
        how="vertical",
    ).sort(by=["currency", "date"])
    logger.info(f"Data appended with shape {updated_data.shape}")

    ds.write_dataset(
        data=updated_data.to_arrow(),
        base_dir=s3_uri,
        format="parquet",
        partitioning=ds.partitioning(
            schema=pa.schema([("currency", pa.string())]), flavor="hive"
        ),
        existing_data_behavior="delete_matching",
    )

    return None


def main() -> int:
    logger.info(f"Running in {ENV} environment")
    new_data: pl.DataFrame = construct_data_frame()
    write_to_s3(new_data)
    return 0


if __name__ == "__main__":
    main()
