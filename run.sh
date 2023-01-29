#!/bin/bash

ansible-playbook install.yaml -i inventory/hosts.yaml

## FOR more DEBUG info
#ansible-playbook -vvv install.yaml -i inventory/hosts.yaml