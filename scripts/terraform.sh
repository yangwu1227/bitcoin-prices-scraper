#!/bin/bash

original_dir=$(pwd)

read -p "Enter the path to the Terraform configuration directory: " tf_config_path
read -p "Environment (dev/prod) [optional]: " environment

# Check if the directory exists
if [ ! -d "$tf_config_path" ]; then
    echo "Directory not found; please enter a valid path"
    exit 1
fi

cd "$tf_config_path"

terraform fmt 

# Initialize the Terraform configuration using backend.hcl
if [ -n "$environment" ]; then
    terraform init -backend-config=backend_$environment.hcl
else
    terraform init -backend-config=backend.hcl
fi

# Validate 
terraform validate

# Apply the Terraform configuration
terraform apply -var-file=variables.tfvars

cd "$original_dir"
