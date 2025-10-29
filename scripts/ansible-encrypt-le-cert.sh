echo "$ANSIBLE_VAULT_PASSWORD" >/tmp/.vault_pass
chmod 600 /tmp/.vault_pass

ansible-vault encrypt lets-encrypt-certs/teleport.key --vault-password-file /tmp/.vault_pass
ansible-vault encrypt lets-encrypt-certs/teleport.crt --vault-password-file /tmp/.vault_pass

rm /tmp/.vault_pass
