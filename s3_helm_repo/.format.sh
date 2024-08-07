#!/bin/bash
# run terraform init with the remote backend
# echo "running terraform init"
# terraform init
terraform init -backend-config="./env/.backend.tfvars"
#terraform init -var-file=<"./env/**/.terraform.tfvars"> -backend-config=<"./env/**/backend.tfvars">

#run terrafeom fmt in all subsequent directoies with .tf files
echo "formatting all terraform files"
# find . -name "*.tf" -execdir terraform fmt \;

# Run terraform fmt in all subdirectories
find . -type d -exec sh -c 'cd "{}" && terraform fmt' \;

echo "validating terraform configuration"
terraform validate