#!/usr/bin/env bash
#
# Author    :   Rory Swann {rory@shirenet.io}
# Purpose   :   A simple script to allow package updates for Proxmox without a subscription

ENT_SRC="/etc/apt/sources.list.d/pve-enterprise.list"
ENT_SRC_BAK="/tmp/pve-enterprise.list"
FREE_SRC="/etc/apt/sources.list.d/pve-no-subscription.list"

disableEntSrc() {
    sed -e '/deb https:\/\/enterprise.proxmox.com\/debian\/pve buster pve-enterprise/ s/^#*/#/' -i ${ENT_SRC}
}

mkNoSubSrc() {
    echo "deb http://download.proxmox.com/debian/pve buster pve-no-subscription" > ${FREE_SRC}
}

updatePkgs() {
    apt-get update && apt-get dist-upgrade -y
}

enableEntSrc() {
    sed -i '/^#.* buster /s/^#//' ${ENT_SRC}
}

backupEntSrc() {
    cp ${ENT_SRC} ${ENT_SRC_BAK}
}

restoreEntSrc() {
    if [ ! -f ${ENT_SRC_BAK} ]; then
        echo "No backup exists"
        echo "Do you want to attempt to enable from the current source file? y/n"
        read answer
        if [ $answer == "y" ]; then
            enableEntSrc
        elif [ $answer == "n" ]; then
            exit 1
        else
            echo "Answer y or n..."
        fi
    else
        rm -f ${ENT_SRC}
        cp ${ENT_SRC_BAK} ${ENT_SRC}
    fi
}

checkRoot() {
    if [ ! $USER == "root" ]; then
        false
    elif [ $USER == "root" ]; then
        true
    fi
}

printHelp() {
    echo
    echo "Usage: proxmox-update.sh {optional_argument}"
    echo
    echo "Optional arguments:"
    echo
    echo " * disable-enterprise-src     ### Disable Enterprise package source"
    echo " * make-free-source           ### Create free package source file"
    echo " * update-only                ### Run the update process only"
    echo " * backup-enterprise          ### Backup the Enterprise source file"
    echo " * restore-enterprise         ### Restore the Enterprise source file"
    echo
    echo "Executing without optional arguments will configure the source files, create backups and update the packages"
    echo
}

main() {

    echo "Disabling Proxmox Enterprise source if enabled..."
    sleep 1
    if [ ! -f $ENT_SRC_BAK ]; then
        backupEntSrc
        disableEntSrc
    else
        disableEntSrc
    fi

    echo "Creating Proxmox no subscription source..."
    sleep 1
    mkNoSubSrc

    echo "Updating packages..."
    sleep 1
    updatePkgs
}

if ! checkRoot; then
    echo "Script must be run as root"
    exit 1
elif [ -z $1 ]; then
    main
elif [ $1 == "disable-enterprise-src" ]; then
    disableEntSrc
elif [ $1 == "make-free-source" ]; then
    mkNoSubSrc
elif [ $1 == "update-only" ]; then
    updatePkgs
elif [ $1 == "backup-enterprise" ]; then
    backupEntSrc
elif [ $1 == "restore-enterprise" ]; then
    restoreEntSrc
elif [[ $1 == "help" || $1 == "-h" || $1 == "h" ]]; then
    printHelp
else
    printHelp
fi