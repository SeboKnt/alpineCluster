#!/bin/bash

# check if we are in a Github codespace / Ubuntu environment
if ! [  -n "$(uname -a | grep Ubuntu)" ]; then
   echo "You are not on a ubuntu environment. This script prepares github codespace!"
    exit
fi

# create ssh key; Your input is required :(
ssh-keygen -t rsa -b 4096

# install ansible
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt update -y
sudo apt install ansible -y

# install terraform
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# create the server
terraform -chdir=./infrastructure/ init
terraform -chdir=./infrastructure/ apply

sleep 20s

# preps the server for ansible
server=("schwalbe" "spatz" "zwerggans" "colibri" "kiwi")
for hosts in "${server[@]}"
do
   ssh-keyscan $hosts
   ssh-copy-id -i ~/.ssh/*.pub root@$hosts.youngandhungry.org
   ssh root@$hosts.youngandhungry.org "apk add python3"
   ssh root@$hosts.youngandhungry.org "echo $hosts > /etc/hostname"
   ssh root@$hosts.youngandhungry.org "reboot"
done

sleep 5s