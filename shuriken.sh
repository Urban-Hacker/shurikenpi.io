#!/bin/bash

command=$1
shift
cd ./Scripts

if [[ $command == "stop" ]]; then
    ./stop.sh $@
fi
if [[ $command == "start" ]]; then
    ./start.sh $@
fi
if [[ $command == "run" ]]; then
    ./start.sh $@
fi
if [[ $command == "status" ]]; then
    ./status.sh $@
fi
if [[ $command == "config" ]]; then
    ./create_configuration.sh $@
fi
if [[ $command == "monitor" ]]; then
    ./monitor.sh $@
fi
if [[ $command == "miner" ]]; then
    ./monitor.sh $@
fi
if [[ $command == "help" ]]; then
    ./help.sh $@
fi