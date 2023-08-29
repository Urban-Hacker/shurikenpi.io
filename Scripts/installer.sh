 
install_prerequisites(){
    p "Installing pre-requisites..."
    spin_it "goland-go (1/6)" sudo apt-get install -y golang-go
    spin_it "gum       (2/6)" go install github.com/charmbracelet/gum@latest
    spin_it "git       (3/6)" sudo apt-get install -y git
    spin_it "tor       (4/6)" sudo apt-get install -y tor
    spin_it "curl      (5/6)" sudo apt-get install -y curl
    spin_it "screen    (6/6)" sudo apt-get install -y screen
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

do_update() {
    spin_it "Updating, please wait..." sudo apt-get update
}

check_if_upgrade(){

    UPGRADABLE_COUNT=$(apt list --upgradable 2>$LOGS| grep -c ^)
    if (( UPGRADABLE_COUNT > 0 )); then
        p_warn "There are $UPGRADABLE_COUNT packages that can be upgraded."
        p_warn "It is recommended to run 'sudo apt upgrade' after ShurikenPi installation"
    else
        p "All packages are up to date."
    fi
}

clone_repository(){
    spin_it "Downloading ShurikenPi, please wait..." git clone $GIT_URL
}

# Entry point
check_if_root
do_update
install_prerequisites
check_if_upgrade
go_to_install_directory
clone_repository

cd $GIT_FOLDER/Scripts/
./create_configuration.sh