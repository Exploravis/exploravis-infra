#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(pwd)"
TF_DIR="$ROOT_DIR/terraform"

echo "Running Terraform in directory: $TF_DIR"

terraform -chdir="$TF_DIR" init -input=false

terraform -chdir="$TF_DIR" refresh

terraform -chdir="$TF_DIR" plan -out=tfplan -input=false

terraform -chdir="$TF_DIR" apply -input=false tfplan

echo "Terraform run completed successfully."
