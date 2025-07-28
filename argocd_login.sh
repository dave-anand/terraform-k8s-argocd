#!/bin/bash
set -e

# Get password from Terraform output
PASSWORD=$(terraform output -raw argocd_initial_admin_password)

# Set Argo CD server address
ARGOCD_SERVER="localhost:8080"

# Login
argocd login $ARGOCD_SERVER \
  --username admin \
  --password "$PASSWORD" \
  --insecure
