output "s3_bucket_arn" {
  value       = aws_s3_bucket.bitcoin_prices_scraper.arn
  description = "The ARN of the S3 bucket"
}
