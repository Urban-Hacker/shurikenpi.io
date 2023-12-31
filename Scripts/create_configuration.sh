#!/bin/bash

source ./global.sh
source ./utils.sh

new_configuration(){
    msg logo.txt
    p "We will create a new configuration."
    user_pause
    msg wallet_suggestions.txt
    r "Your bitcoin address:" address
    #python3 ../Tools/address_validation.py $address
    echo ""
    echo -e "  \033[33m?\033[0m Which mining pool would you like to use?"
    mining_pool=$(gum choose --cursor=  ›  public-pool.io solo.ckpool.org custom)
    p_user $mining_pool

    if [[ $mining_pool == "custom" ]]; then
        r "Mining pool stratum URL:" $mining_pool
    fi
    echo ""
    p "Creating worker.sh"
    python3 ../Tools/create_worker.py $mining_pool $address > ../Worker/worker.sh
    chmod +x ../Worker/worker.sh
    echo "address: $address" > ../Worker/worker.conf
    echo "pool: $mining_pool" >> ../Worker/worker.conf
    p "Ready to boil the oceans captain!"
    p "To start mining, use the command 'shuriken start'"
    p "To get help, use the command 'shuriken help'"
    echo ""
}

new_configuration