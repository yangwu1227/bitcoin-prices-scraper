terraform {
  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.profile
}

module "s3" {
  source         = "../../modules"
  project_prefix = var.project_prefix
  environment    = var.environment
  s3_bucket      = var.s3_bucket
}
