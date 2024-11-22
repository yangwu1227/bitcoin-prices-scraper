variable "region" {
  type        = string
  description = "AWS region where resources will be deployed"
}

variable "profile" {
  type        = string
  description = "AWS configuration profile with AdministratorAccess permissions"
}

variable "bucket" {
  type        = string
  description = "Name of the S3 bucket where the dev and prod Terraform state files are stored"
}

variable "key_prefix" {
  type        = string
  description = "S3 key prefix for the dev and prod Terraform state files"
}

variable "project_prefix" {
  type        = string
  description = "Prefix to use when naming all resources for the project"
}

variable "github_oidc_provider_arn" {
  type        = string
  description = "Amazon Resource Name (ARN) of the GitHub OIDC provider for authentication"
}

variable "github_username" {
  type        = string
  description = "GitHub username for accessing the repository"
}

variable "github_repo_name" {
  type        = string
  description = "Name of the GitHub repository for this project"
}
