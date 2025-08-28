#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(pwd)"
TF_DIR="$ROOT_DIR/terraform"
PY_SCRIPT="$ROOT_DIR/scripts/generate_ansible_inv.py"
ARTIFACTS_DIR="$ROOT_DIR/ansible/inventories"
PLAYBOOK="$ROOT_DIR/ansible/playbooks/playbook.yml"
ANSIBLE_CFG="$ROOT_DIR/ansible/ansible.cfg"

echo "$ROOT_DIR"
echo "$ARTIFACTS_DIR"

terraform -chdir="$TF_DIR" output -json | python3 "$PY_SCRIPT" --output-dir="$ARTIFACTS_DIR"
