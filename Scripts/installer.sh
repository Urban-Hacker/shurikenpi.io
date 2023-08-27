 
install_prerequisites(){
    p "Installing pre-requisites..."
    spin_it "goland-go (1/5)" sudo apt-get install -y golang-go
    spin_it "gum       (2/5)" go install github.com/charmbracelet/gum@latest && sleep 0.1
    spin_it "git       (3/5)" sudo apt-get install -y git && sleep 0.1
    spin_it "tor       (4/5)" sudo apt-get install -y tor && sleep 0.1
    spin_it "curl      (5/5)" sudo apt-get install -y curl && sleep 0.1
}

go_to_install_directory(){
    echo ""
    cd ~
    local install_folder="$(pwd)/shurikenpi"
    p "Install directory will be: $install_folder"
    if [ -d $install_folder ]; then
        echo ""
        p_warn "An existing installation of ShurikenPi was detected!"
        ask_yes_or_no "Would you like to re-install ShurikenPi and wipe the existing installation?"
        local result=$?
        if [ $result == 0 ]; then
            rm -fr $install_folder
        else
            p_err "Fatal: Aborting the installation script now"
            exit 1
        fi
    fi
    mkdir $install_folder
    cd $install_folder
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

do_update() {
    spin_it "Updating, please wait..." sudo apt update
}

check_if_upgrade(){

    UPGRADABLE_COUNT=$(apt list --upgradable 2>/dev/null | grep -c ^)
    if (( UPGRADABLE_COUNT > 0 )); then
        p_warn "There are $UPGRADABLE_COUNT packages that can be upgraded."
        p_warn "It is recommended to run 'sudo apt upgrade' after ShurikenPi installation"
    else
        p "All packages are up to date."
    fi
}

clone_repository(){
    spin_it "Downloading ShurikenPi, please wait..." git clone https://github.com/Urban-Hacker/shurikenpi.io/
}

create_tmp_log_directory() {
    rm -fr /tmp/shuriken 2>&1
    mkdir /tmp/shuriken 2>&1
}


VERBOSE=0

# check if -v is passed as argument
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

create_tmp_log_directory

# Entry point
check_if_root
do_update
install_prerequisites
check_if_upgrade
go_to_install_directory
clone_repository
cd ./shuriken/Tools/
chmod +x dependencies.sh
./dependencies.sh