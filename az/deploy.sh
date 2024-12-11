#!/bin/bash
set -e

export $(grep -v '^#' .env | xargs)

printf "Provisioning the LCA Collaboration server...\n"
terraform init
terraform apply

printf "\nDeployment completed successfully!\n"
