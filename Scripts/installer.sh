 
install_prerequisites(){
    p "Installing pre-requisites..."
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --batch --yes --dearmor -o /etc/apt/keyrings/charm.gpg
    echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list >/dev/null

    if [[ "$ARCHITECTURE" == "aarch64" ]]; then
        spin_it "dpkg --add-architecture armhf                                             \033[32m✓\033[0m" sudo dpkg --add-architecture armhf
    fi
    spin_it "Update cache..." sudo apt update
    spin_it "apt install gum                                                           \033[32m✓\033[0m" sudo apt-get install -y gum
    spin_it "apt install git                                                           \033[32m✓\033[0m" sudo apt-get install -y git
    spin_it "apt install tor                                                           \033[32m✓\033[0m" sudo apt-get install -y tor
    spin_it "apt install curl                                                          \033[32m✓\033[0m" sudo apt-get install -y curl
    spin_it "apt install screen                                                        \033[32m✓\033[0m" sudo apt-get install -y screen

    if [[ "$ARCHITECTURE" == "aarch64" ]]; then
        spin_it "apt install libc6:armhf                                                   \033[32m✓\033[0m" sudo apt-get install -y libc6:armhf
        spin_it "apt install libstdc++6:armhf                                              \033[32m✓\033[0m" sudo apt-get install -y libstdc++6:armhf
        spin_it "apt install libcurl4:armhf                                                \033[32m✓\033[0m" sudo apt-get install -y libcurl4:armhf
        spin_it "apt install libssl1.1:armhf                                               \033[32m✓\033[0m" sudo apt-get install -y libssl1.1:armhf
        spin_it "apt install libjansson4:armhf                                             \033[32m✓\033[0m" sudo apt-get install -y libjansson4:armhf
    fi
}

go_to_install_directory(){
    echo ""
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

if ! grep -q "alias shuriken=" ~/.bashrc; then
    echo "alias shuriken=$GIT_FOLDER/shuriken.sh" >> ~/.bashrc
fi
source ~/.bashrc

cd $GIT_FOLDER/
./shuriken.sh config