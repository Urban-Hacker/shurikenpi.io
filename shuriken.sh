#!/bin/bash

command=$1
shift

{
    cd ~/shurikenpi/shurikenpi.io/Scripts

    if [[ $command == "stop" ]]; then
        ./stop.sh $@
    elif [[ $command == "start" ]]; then
        ./start.sh $@
    elif [[ $command == "run" ]]; then
        ./start.sh $@
    elif [[ $command == "status" ]]; then
        ./status.sh $@
    elif [[ $command == "config" ]]; then
        ./create_configuration.sh $@
    elif [[ $command == "monitor" ]]; then
        ./monitor.sh $@
    elif [[ $command == "miner" ]]; then
        ./monitor.sh $@
    elif [[ $command == "test" ]]; then
        ./selftest.sh $@
    elif [[ $command == "help" ]]; then
        ./help.sh $@
    elif [[ $command == "version" ]]; then
        ./version.sh $@
    else
        echo "  » Unknown command. Not sure what you are trying to do :("
        echo "  » Run 'shuriken help' to show the built-in user manual"
    fi
}