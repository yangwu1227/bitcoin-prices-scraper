resource "aws_s3_bucket" "bitcoin_prices_scraper" {
  bucket = "${var.s3_bucket}-${var.environment}"
  tags = {
    project = "${var.project_prefix}_${var.environment}"
  }
}
