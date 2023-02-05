#!/bin/bash

sudo apt-add-repository ppa:ansible/ansible -y
sudo apt update -y
sudo apt install ansible -y

ssh-keygen -t rsa -b 4096

wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

terraform init
terraform apply

sleep 20s

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