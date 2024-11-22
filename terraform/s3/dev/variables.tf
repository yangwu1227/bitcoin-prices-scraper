variable "region" {
  type        = string
  description = "AWS region where resources will be deployed"
}

variable "profile" {
  type        = string
  description = "AWS configuration profile with AdministratorAccess permissions"
}

variable "project_prefix" {
  type        = string
  description = "Prefix to use when naming all resources for the project"
}

variable "environment" {
  type        = string
  description = "Environment to deploy the project to"
}

variable "s3_bucket" {
  type        = string
  description = "Name of the S3 bucket for storing scrapper data"
}

