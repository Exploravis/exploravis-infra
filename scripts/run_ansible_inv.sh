#!/usr/bin/env bash
set -euo pipefail

# Root directory of your project
ROOT_DIR="$(pwd)"
INVENTORY_DIR="$ROOT_DIR/ansible/inventories"
PLAYBOOK="$ROOT_DIR/ansible/playbooks/playbook.yml"
ANSIBLE_CFG="$ROOT_DIR/ansible/ansible.cfg"

export ANSIBLE_CONFIG="$ANSIBLE_CFG"

echo "Using inventories from: $INVENTORY_DIR"
echo "Using playbook: $PLAYBOOK"

for inventory_file in "$INVENTORY_DIR"/*; do
  if [[ -f "$inventory_file" ]]; then
    echo "Running playbook on inventory: $inventory_file"
    ansible-playbook -i "$inventory_file" "$PLAYBOOK"
    echo "----------------------------------------"
  fi
done
