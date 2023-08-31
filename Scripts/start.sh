source ./global.sh
source ./utils.sh

if [ $SESSION_COUNT -eq 0 ]; then
    p "Starting up shurikenpi.io..."
    screen -d -m -c ../Configurations/screen.screenrc -S "shurikenpi.io" ../Worker/worker.sh
    ./status.sh
elif [ $SESSION_COUNT -eq 1 ]; then
    p "shurikenpi.io is already running"
else
    ./status.sh
fi
