#!/bin/bash
USAGE="bash createSecrets.sh <variable> <password>"
path="./inventory/group_vars/all.yaml"

if [ -z "$2" ]
then
  echo "PLEASE USE THE SYNTAX: $USAGE"
  exit
fi

secret=$(ansible-vault encrypt_string $2 --ask-vault-pass)
echo "$1: $secret" >> $path
echo "folgendes wurde in $path gespeichert"
tail -n 7 $path

# HIER FEHLT NOCH GANZE DATEIEN ZU VERSCHLÜSSELN
# https://docs.ansible.com/ansible/latest/vault_guide/vault_encrypting_content.html