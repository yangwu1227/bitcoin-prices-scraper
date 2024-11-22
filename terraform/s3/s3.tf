resource "aws_s3_bucket" "bitcoin_price_scraper" {
  bucket = var.s3_bucket
  tags = {
    project = var.project_prefix
  }
}
