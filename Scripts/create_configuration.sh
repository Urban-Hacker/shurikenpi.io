#!/bin/bash

source ./global.sh
source ./utils.sh
msg logo.txt
p "We will create a new configuration"
r "Your bitcoin address:" address
#python3 ../Tools/address_validation.py $address

echo -e "  \033[33m?\033[0m Which mining pool would you like to use?"
mining_pool=$(gum choose --cursor=  ›  public-pool.io solo.ckpool.org custom)
p_user $mining_pool

if [[ $mining_pool == "custom" ]]; then
    r "Mining pool stratum URL:" $mining_pool
fi

echo "->" $mining_pool