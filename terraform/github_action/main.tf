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

locals {
  environments = ["dev", "prod"]
}

data "terraform_remote_state" "s3" {
  for_each = toset(local.environments)
  backend  = "s3"
  config = {
    bucket  = var.bucket
    key     = "${var.key_prefix}/${each.key}/terraform.tfstate"
    region  = var.region
    profile = var.profile
  }
}
