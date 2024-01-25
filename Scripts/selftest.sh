source ./global.sh
source ./utils.sh

if [ $SESSION_COUNT -eq 1 ]; then
    p_warn "shurikenpi.io is already running"
    p "You must stop it before running internal test"
    exit 0
fi

p "Starting interal self-test"

if ping -c 1 8.8.8.8 &> /dev/null
then
  p_ok "Internet is accessible."
else
  p_warn "No internet access."
fi

p "Running the mining process for 1 min"
p_warn "Please do not force stop the process during the test"
timeout 1m ../Worker/worker.sh