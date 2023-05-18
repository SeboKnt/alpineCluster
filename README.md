# Alpine Cluster

## Description

With this project you can create a k3s Cluster from scratch. 

- creates the server via terraform
- installs k3s on the server
- mounts flux repo

## Usage

First of all you will need a Hetzner Cloud Projekt and a Hetzner Cloud Token. Instructions can be found [here](https://docs.hetzner.com/cloud/api/getting-started/generating-api-token/)

Then please check if Terraform and Ansible is installed on your device:

``` 
terraform-v
ansible -v
```

If you are on github Codespaces you can use the bash script [prepCodespace.sh](prepCodespace.sh)

After that please c


# Run Ansible

`ansible-playbook -install.yaml -i inventory/<inventory.yaml> --ask-vault-pass`