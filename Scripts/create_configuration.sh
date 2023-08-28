#!/bin/bash

source ./global.sh
source ./utils.sh
msg logo.txt
p "create a new configuration"
r "Your bitcoin address:" address
python3 ../Tools/address_validation.py $address