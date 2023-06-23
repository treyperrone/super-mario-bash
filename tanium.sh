#!/usr/bin/env bash
#
# <scriptname>      Tanium linux installer
#
# Description:      This script handles Tanium
#

#error stoppage
#set -ex
set -eou pipefail

echo "Running check that we are escalated with sudo or as root..."
if [[ `id -u` -ne 0 ]]; then
    echo "This script must be run as root or with sudo <./scriptname>!"
    exit 1
fi
echo "Escalation check passed successfully!"


## Create a variable for $OS based off output of hostnamectl, fail otherwise
# OS=$(hostnamectl | grep -i "operating system:") # grep on "operating system" only
# # OS=$(hostnamectl)
# if [ "$?" -ne 0 ]; then
#     echo 'Error running hostnamectl!'
#     exit 1
# fi


## https://docs.tanium.com/client/client/requirements.html?cloud=true#table_client_host_system_requirements
## Match the $OS variable as a supported OS to continue, else fail
echo "Running checks to match supported Operating Systems...."
# case "$OS" in # comment out and call command subsitution direct
case $(hostnamectl | grep -i "operating system:") in
    *Amazon\ Linux\ 2)
        OS="amzn2"
        OS_ARCH="$(arch)"
        PKG_MGR="yum"
    ;;
    
    *Red\ Hat\ Enterprise\ Linux\ 8.*)
        OS="rhe8"
        OS_ARCH="$(arch)"
        PKG_MGR="dnf"
    ;;
    
    *Red\ Hat\ Enterprise\ Linux\ 7.*)
        OS="rhe7"
        OS_ARCH="$(arch)"
        PKG_MGR="yum"
    ;;

    *Ubuntu\ 22.*)
        OS="ubuntu22"
        OS_ARCH="$(dpkg --print-architecture)"
        PKG_MGR="apt-get"
        DEBIAN_FRONTEND="noninteractive"      
    ;;

    *Ubuntu\ 20.*)
        OS="ubuntu20"
        OS_ARCH="$(dpkg --print-architecture)"
        PKG_MGR="apt-get"
        DEBIAN_FRONTEND="noninteractive"
    ;;

    *)
        echo "$(hostnamectl | grep -i "operating system:") is not currently supported!"
        exit 1
        ;;
esac
echo "Operating System check passed successfully!"
echo "Variables have been set for
OS == $OS (from $(hostnamectl | grep -i "operating system:"))
OS_ARCH == $OS_ARCH
PKG_MGR == $PKG_MGR"
