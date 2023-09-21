source ./global.sh
source ./utils.sh

if [ $SESSION_COUNT -eq 0 ]; then
    ./status.sh
elif [ $SESSION_COUNT -eq 1 ]; then
    p "Starting shurikenpi.io monitoring tool..."
    sleep 1
    p "This will open a new terminal. To exit press CTR + A + D"
    p "This will not stop the miner"
    sleep 3
    p "Launching in 3"
    sleep 1
    p "Launching in 2"
    sleep 1
    p "Launching in 1"
    sleep 1
    p "Launching now"
    sleep 2
    screen -R shurikenpi.io
else
    ./status.sh
fi
