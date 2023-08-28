#!/bin/bash

build_installer(){
    # Header
    echo "#!/bin/bash" > install.sh
    echo "# File generated automatically by build.sh. Do not modify" >> install.sh
    echo "# DO NOT MODIFY" >> install.sh
    echo "" >> install.sh

    cat Scripts/global.sh >> install.sh
    echo -e "\n\n" >> install.sh
    cat Scripts/utils.sh >> install.sh
    echo -e "\n\n" >> install.sh
    cat Scripts/installer.sh >> install.sh
    chmod +x install.sh
}

echo -e "Script to build Shuriken"
build_installer
echo "Finished"