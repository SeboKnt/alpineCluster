#!/bin/bash

server=("schwalbe" "spatz" "zwerggans")

for hosts in "${server[@]}"
do
   ssh-copy-id -i ~/.ssh/*.pub root@$hosts
   ssh root@$hosts.youngandhungry.org "apk add python3"
done