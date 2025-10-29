#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(pwd)"
INVENTORY_DIR="$ROOT_DIR/ansible/inventories"
PLAYBOOK_TELEPORT="$ROOT_DIR/ansible/playbooks/install-teleport.yml"
ANSIBLE_CFG="$ROOT_DIR/ansible/ansible.cfg"

export ANSIBLE_CONFIG="$ANSIBLE_CFG"

echo "Using inventories from: $INVENTORY_DIR"
echo "----------------------------------------"

TMP_PASSFILE=$(mktemp)
echo "$ANSIBLE_VAULT_PASSWORD" >"$TMP_PASSFILE"
chmod 600 "$TMP_PASSFILE"

shopt -s nullglob
for inventory_file in "$INVENTORY_DIR"/*; do
  if [[ -f "$inventory_file" ]]; then
    echo "Running playbook on inventory: $inventory_file "
    # ansible-playbook -i "$inventory_file" "$PLAYBOOK_TELEPORT"
    ansible-playbook -i "$inventory_file" "$PLAYBOOK_TELEPORT" \
      --vault-password-file "$TMP_PASSFILE"
    echo "----------------------------------------"
  fi
done

rm -f "$TMP_PASSFILE"
