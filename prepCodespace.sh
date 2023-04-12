#!/bin/bash

# check if we are in a Github codespace / Ubuntu environment
if ! [  -n "$(uname -a | grep Ubuntu)" ]; then
   echo "You are not on a ubuntu environment. This script prepares github codespace!"
    exit
fi

# create ssh key; Your input is required :(
ssh-keygen -t rsa -b 4096 -f /home/codespace/.ssh/id_rsa -q -N ""

# install ansible
sudo apt-add-repository ppa:ansible/ansible -y
sudo apt update -y
sudo apt install ansible -y

# install terraform
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# install sops (thx to Techno Tim - docs.technotim.live)
SOPS_LATEST_VERSION=$(curl -s "https://api.github.com/repos/mozilla/sops/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+')
curl -Lo sops.deb "https://github.com/mozilla/sops/releases/latest/download/sops_${SOPS_LATEST_VERSION}_amd64.deb"
sudo apt --fix-broken install ./sops.deb
rm -rf sops.deb

# install age 
AGE_LATEST_VERSION=$(curl -s "https://api.github.com/repos/FiloSottile/age/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+')
curl -Lo age.tar.gz "https://github.com/FiloSottile/age/releases/latest/download/age-v${AGE_LATEST_VERSION}-linux-amd64.tar.gz"
tar xf age.tar.gz
sudo mv age/age /usr/local/bin
sudo mv age/age-keygen /usr/local/bin
rm -rf age.tar.gz
rm -rf age

# mv sops to the right place
## gpg -c <file> # encrypted the file
mkdir ~/.sops
gpg -o ~/.sops/key.txt -d .sops/key.txt.gpg

# set bashrc
echo "export SOPS_AGE_KEY_FILE=$HOME/.sops/key.txt" >> ~/.bashrc
source ~/.bashrc


# create the server
##terraform -chdir=./infrastructure/ init
##terraform -chdir=./infrastructure/ apply
##
##sleep 20s
##
### preps the server for ansible
##server=("schwalbe" "spatz" "zwerggans" "colibri" "kiwi")
##for hosts in "${server[@]}"
##do
##   ssh-keyscan $hosts
##   ssh-copy-id -i ~/.ssh/*.pub root@$hosts.youngandhungry.org
##   ssh root@$hosts.youngandhungry.org "apk add python3"
##   ssh root@$hosts.youngandhungry.org "echo $hosts > /etc/hostname"
##   ssh root@$hosts.youngandhungry.org "reboot"
##done
##
##sleep 5s