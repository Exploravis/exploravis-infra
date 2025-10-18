#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(pwd)"
INVENTORY_DIR="$ROOT_DIR/ansible/inventories"
PLAYBOOK="$ROOT_DIR/ansible/playbooks/playbook.yml"
PLAYBOOK_2="$ROOT_DIR/ansible/playbooks/teleport.yml"
ANSIBLE_CFG="$ROOT_DIR/ansible/ansible.cfg"

export ANSIBLE_CONFIG="$ANSIBLE_CFG"

echo "Using inventories from: $INVENTORY_DIR"
echo "Using playbook: $PLAYBOOK"
echo "----------------------------------------"

shopt -s nullglob
for inventory_file in "$INVENTORY_DIR"/*; do
  if [[ -f "$inventory_file" ]]; then
    echo "Running playbook on inventory: $inventory_file "
    ansible-playbook -i "$inventory_file" "$PLAYBOOK"
    # ansible-playbook -i "$inventory_file" "$PLAYBOOK_2"
    echo "----------------------------------------"
  fi
done
