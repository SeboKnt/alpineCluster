#!/bin/bash

ssh-keygen -t rsa -b 4096

server=("schwalbe" "spatz" "zwerggans")

for hosts in "${server[@]}"
do
   ssh-copy-id -i ~/.ssh/*.pub root@$hosts.youngandhungry.org
   ssh root@$hosts.youngandhungry.org "apk add python3"
done