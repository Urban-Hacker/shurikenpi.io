source ./global.sh
source ./utils.sh

if [[ $VERBOSE -eq 1 ]]; then
    if [[ $INSTALLED_TYPE -eq $DEV ]]; then
        p_warn "Development Mode"
    fi
    if [[ $INSTALLED_TYPE -eq $DEV_DETACHED ]]; then
        p_warn "Development Mode - Detached HEAD state"
    fi
    if [[ $INSTALLED_TYPE -eq $STABLE ]]; then
        p_ok "Stable Version"
    fi
fi
p $INSTALLED_VERSION