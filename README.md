# shurikenpi.io
Bitcoin Mining on a RaspberryPi

# Instructions

Please be aware that currently this project is in Beta and not yet ready to be widely used.

## Hardware requirements

The current recommended requirements is a Raspberry Pi model 4 (the RAM does not really matter) with the default operating system already installed on it.
It is also recommended to use a dedicated device since mining might use ressources from other process and make them slower than usual.

## Installation

1) Open the terminal of your raspberry pi (or connect to it through SSH)
2) Ensure you are in the home repository

$ cd ~

3) Download shurikenpi

$ wget https://raw.githubusercontent.com/Urban-Hacker/shurikenpi.io/main/install.sh

4) Make it executable

$ chmod +x ./install.sh

5) Run it

$ ./install.sh

6) Follow the instructions in the installation wizard
7) Once installed, you will need to go in the directory where ShurikenPi is installed. In the future this will not be necessary.

cd ~/shurikenpi/shurikenpi.io

8) To start shuriken pi you can use the start command. To stop it or get the status use stop or status. See example bellow:

$ ./shuriken.sh start

# Credits

* NerdMiner (https://github.com/BitMaker-hub/NerdMiner_v2)
* The authors of cpuminer-multi (https://github.com/tpruvot/cpuminer-multi)
