#!/bin/bash

r(){
    p $1
    while read -t 0; do :; done
    read -p "  › " $2
}

p() {
    echo -e "  » $1"
    sleep 0.1
}

p_user() {
    echo -e "  \e[35m› $1\033[0m"
    sleep 0.1
}

p_err(){
    echo -e "  \033[31m»\033[0m $1"
    sleep 0.1
}

p_fatal(){
    echo -e "  \033[31m» $1\033[0m"
    sleep 0.1
}

p_ok(){
    echo -e "  \033[32m»\033[0m $1"
    sleep 0.1
}

p_warn(){
    echo -e "  \033[33m!\033[0m $1"
    sleep 0.1
}

msg() {
    echo ""
    sleep 0.1
    while IFS= read -r line
    do
        echo -e "$line"
        sleep 0.1
    done < "../Messages/$1"
    echo "$line"
    sleep 0.1
    echo ""
    sleep 0.1
}

ask_yes_or_no(){
    echo -e "  \033[33m?\033[0m $1"
    local result=$(gum choose --cursor=  ›   Yes No)
    if [[ $result == "Yes" ]]; then
        p_user "Yes"
        return 0
    fi
    p_user "No"
    return 1
}

user_pause(){
    local result=$(gum choose --cursor=" › " "Continue")
    p_user "Continue"
}

spin_it(){
    local msg=$1
    shift
    local command=$@
    local hash=$(echo -n "$command" | md5sum | awk '{print $1}')
    local logfile="$TMP_DIRECTORY/$hash.txt"
    "$@" > $logfile 2>&1 &
    chars=("  ⠋ " "  ⠙ " "  ⠹ " "  ⠸ " "  ⠼ " "  ⠴ " "  ⠦ " "  ⠧ " "  ⠇ " "  ⠏ ")
    pid=$!
    while kill -0 $pid 2> /dev/null; do
        for char in "${chars[@]}"; do
            echo -ne "\r$char"
            sleep 0.1
        done
    done
    wait $pid
    local exit_status=$?
    echo -ne "\r\033[K"
    if [ $exit_status -eq 0 ]; then
        p $msg
    else
        p_fatal "$msg [FATAL ERROR]"
        p_fatal "--- BEGIN ERROR DUMP ---"
        awk '{print "  \033[31m  " $0 "\033[0m"}' $logfile
        p_fatal "--- END ERROR DUMP ---"
        exit 1
    fi
    if [ $VERBOSE -eq 1 ]; then
        awk '{print "  ‣ " $0}' $logfile
        echo ""
    fi
}
