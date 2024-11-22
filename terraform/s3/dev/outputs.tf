output "s3_bucket_arn" {
  value       = module.s3.s3_bucket_arn
  description = "The ARN of the S3 bucket outputted by the module"
}
