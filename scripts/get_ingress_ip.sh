#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(pwd)"
TF_DIR="$ROOT_DIR/terraform"
PY_SCRIPT="$ROOT_DIR/scripts/get_ingress_ip.py"

terraform -chdir="$TF_DIR" output -json | python3 "$PY_SCRIPT"
