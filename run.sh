#!/bin/bash

ansible-playbook install.yaml -i inventory/hosts.yaml

## FOR more DEBUG info
#ansible-playbook -vvv install.yaml -i inventory/hosts.yaml

## For Example Ansible secret
#ansible-playbook maintenance.yaml -i inventory/hosts.yaml --ask-vault-pass