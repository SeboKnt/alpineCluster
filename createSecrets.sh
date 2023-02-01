#!/bin/bash
# USAGE: bash createSecrets.sh <variable> <password>

echo $1 >> ./inventory/group_vars/all.yaml

ansible-vault encrypt_string $2 --ask-vault-pass >> ./inventory/group_vars/all.yaml

# HIER FEHLT NOCH GANZE DATEIEN ZU VERSCHLÜSSELN
# https://docs.ansible.com/ansible/latest/vault_guide/vault_encrypting_content.html