#!/bin/bash 
terraform fmt
terraform init -backend-config=./env/backend.tfvars
terraform plan -var-file=./env/.terraform.tfvars
terraform apply --auto-approve -var-file=./env/.terraform.tfvars
