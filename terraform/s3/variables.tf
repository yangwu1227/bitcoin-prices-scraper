variable "project_prefix" {
  type        = string
  description = "Prefix to use when naming all resources for the project"
}

variable "region" {
  type        = string
  description = "AWS region where resources will be deployed"
}

variable "profile" {
  type        = string
  description = "AWS configuration profile with AdministratorAccess permissions"
}

variable "s3_bucket" {
  type        = string
  description = "Name of the S3 bucket for storing scrapper data"
}
