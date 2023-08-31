#!/bin/bash
# File generated automatically by build.sh. Do not modify
# DO NOT MODIFY

#!/bin/bash

VERBOSE=0
while getopts ":v" option; do
    case "${option}" in
        v)
            VERBOSE=1
            ;;
        *)
            echo "Usage: $0 [-v]"
            exit 1
            ;;
    esac
done

LOGS=/dev/null
INSTALLATION_FOLDER="$HOME/shurikenpi"
GIT_FOLDER="$HOME/shurikenpi/shurikenpi.io"
TMP_DIRECTORY=/tmp/shuriken_io

rm -fr $TMP_DIRECTORY 2>&1
mkdir $TMP_DIRECTORY 2>&1

GIT_URL=https://github.com/Urban-Hacker/shurikenpi.io/

SESSION_COUNT=$(screen -ls | grep -c "\.shurikenpi.io")



#!/bin/bash

r(){
    p $1
    while read -t 0; do :; done
    read -p "  › " $2
}

p() {
    echo -e "  » $1"
}

p_user() {
    echo -e "  › $1"
}

p_err(){
    echo -e "  \033[31m»\033[0m $1"
}

p_fatal(){
    echo -e "  \033[31m» $1\033[0m"
}

p_ok(){
    echo -e "  \033[32m»\033[0m $1"
}

p_warn(){
    echo -e "  \033[33m!\033[0m $1"
}

msg() {
    echo ""
    echo -e "$(cat ../Messages/$1)"
    echo ""
}

ask_yes_or_no(){
    echo -e "  \033[33m?\033[0m $1"
    result=$(gum choose --cursor=  ›   Yes No)
    if [[ $result == "Yes" ]]; then
        p_user "Yes"
        return 0
    fi
    p_user "No"
    return 1
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
    exit_status=$?
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


 
install_prerequisites(){
    p "Installing pre-requisites..."
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --batch --yes --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list >/dev/null

    spin_it "Update cache..." sudo apt update
    spin_it "apt install gum                                                           \033[32m✓\033[0m" sudo apt-get install -y gum
    spin_it "apt install git                                                           \033[32m✓\033[0m" sudo apt-get install -y git
    spin_it "apt install tor                                                           \033[32m✓\033[0m" sudo apt-get install -y tor
    spin_it "apt install curl                                                          \033[32m✓\033[0m" sudo apt-get install -y curl
    spin_it "apt install screen                                                        \033[32m✓\033[0m" sudo apt-get install -y screen
}

go_to_install_directory(){
    echo ""
    cd $INSTALLATION_FOLDER
    p "Install directory will be: $INSTALLATION_FOLDER"
    if [ -d $INSTALLATION_FOLDER ]; then
        echo ""
        p_warn "An existing installation of ShurikenPi was detected!"
        ask_yes_or_no "Would you like to re-install ShurikenPi and wipe the existing installation?"
        local result=$?
        if [ $result == 0 ]; then
            rm -fr $INSTALLATION_FOLDER
        else
            p_err "Fatal: Aborting the installation script now"
            exit 1
        fi
    fi
    mkdir $INSTALLATION_FOLDER
    cd $INSTALLATION_FOLDER
}

check_if_root(){
    echo ""
    p "Root user check..."

    if [[ $EUID -ne 0 ]]; then
        echo ""
        echo -e "    ShurikenPi called with non-root priviledeges \033[31m:(\033[0m"
        echo -e "    Elevated priviledeges are required to install and run ShurikenPi"
        echo -e "    Please check the installer for any concerns about this requirement"
        echo -e "    Make sure you downloaded this script from a trusted source"
        echo ""
        if sudo true; then
            p "Correct password."
        else
            p_err "Wrong password. Exiting."
            exit 1
        fi
    fi
    p_ok "We are root :)"
}

check_if_upgrade(){

    UPGRADABLE_COUNT=$(apt list --upgradable 2>$LOGS| grep -c ^)
    if (( UPGRADABLE_COUNT > 0 )); then
        p_warn "There are $UPGRADABLE_COUNT packages that can be upgraded."
        p_warn "It is recommended to run 'sudo apt upgrade' afterwards."
    else
        p "All packages are up to date."
    fi
}

clone_repository(){
    spin_it "Downloading ShurikenPi, please wait..." git clone $GIT_URL
}

# Entry point
check_if_root
echo ""
p "The next steps might take some time, be patient"
install_prerequisites
check_if_upgrade
go_to_install_directory
clone_repository

cd $GIT_FOLDER/Scripts/
./create_configuration.sh