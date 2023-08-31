source ./global.sh
source ./utils.sh

if [ $SESSION_COUNT -eq 0 ]; then
    ./status.sh
elif [ $SESSION_COUNT -eq 1 ]; then
    p "We will stop shurikenpi.io..."
    screen -X -S shurikenpi.io quit
else
    ./status.sh
fi
