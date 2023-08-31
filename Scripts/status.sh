source ./global.sh
source ./utils.sh


if [ $SESSION_COUNT -eq 1 ]; then
    p_ok "shurikenpi.io is running"
elif [ $SESSION_COUNT -gt 1 ]; then
    p_warn "Only one instance of shurikenpi.io should be running"
    p_warn "shurikenpi.io might have been started multiple time."
    p_warn "Please force restart if this is the case."
else
    p_err "shurikenpi.io is not running"
fi