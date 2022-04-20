#!/bin/bash
#
# use this script for fixing repository and package problems in RHEL 8 Kyndryl Open client OS, To be used Kyndryl internal use only 
#
# Use of this script is your sole responsibility and implies that you accept any risk and/or liability associated with executing this on your device.
# This script will pull general and common information for troubleshooting issues.
#
# Created by venkat.naveen@kyndryl.com
# V 1.0; 5th April 2022
#


RED='\033[031m'
NC='\033[0m'

OC_version="$(cat /etc/redhat-release | awk '{print $6}')"

# Checking Root login

if [ ! $( id -u ) -eq 0 ]; then
 echo -e "Root Privilages:${RED}Failed ${NC} Login to root account and try again. Exiting.."
 exit 1
else
 echo -e "Root Privilages:${RED}Success${NC}"
fi

# Checking Intranet Network Connectivity

/usr/bin/ibm-quickresolv > /dev/null

if [ $? -ne 0 ] ;then
  echo -e "Intranet Connection:${RED}Failed${NC} Check VPN connection and try again . Exiting.."
exit 1
else
 echo -e "Intranet Connection:${RED}Connected${NC}"
fi

#clean all packages and metadata
dnf clean all

# Removing Old RPM DataBase Files 
echo "removing old yum DB file(s)"
rm -rf /var/lib/rpm/__db*
rm -rf /var/cache/dnf/*

# Createing new RPM DB files 
echo "re-building DB"
rpm -rebuilddb

# Adding Repository Information 
if [ "$OC_version" = "8.4" ] ; then 
echo -e "OC version : ${RED} $OC_version  ${NC}"
	 dnf config-manager --add-repo  https://ppychemir0101.sl.bluecloud.ibm.com/EL8.4.0/REPO/kyndryl-restricted-QA.repo
fi

if [ "$OC_version" = "8.5" ] ; then
echo -e "OC version:${RED}$OC_version${NC}"
	 dnf config-manager --add-repo  https://ppychemir0101.sl.bluecloud.ibm.com/EL8.5.0/REPO/kyndryl-restricted-QA.repo
fi

# running updates
dnf update -y


