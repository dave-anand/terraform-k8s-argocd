#!/bin/bash
set -e

# Get base64-encoded password from secret
RAW_B64=$(kubectl get secret argocd-initial-admin-secret -n argocd -o json | jq -r '.data.password')

# Decode and sanitize
DECODED=$(echo "$RAW_B64" | base64 --decode | tr -dc '[:print:]' | sed 's/"/\\"/g')

# Output valid JSON
echo "{\"password\": \"$DECODED\"}"
