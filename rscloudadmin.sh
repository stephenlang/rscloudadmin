#!/usr/bin/env bash
#
# rscloudadmin
# Menu driven front end wrapper script for the various Rackspace Cloud Tools.
#
# Copyright (c) 2013, Stephen Lang
# All rights reserved.
#
# Git repository available at:
# https://github.com/stephenlang/rscloudadmin
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
#
# Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.


f_menu() {

bold=`tput smso`
offbold=`tput rmso`
clear

cat << EOF

${bold}\
  Rackspace Cloud Admin Management Console  \
${offbold}\

  Account:  $OS_USERNAME ($OS_TENANT_NAME)


  1)  FirstGen Cloud Servers
  2)  NextGen Cloud Servers
  3)  Cloud Block Storage
  4)  Cloud Networks
  5)  Cloud Load Balancers

  6)  Show Solution Overview 
  
  9)  Quit and Disconnect

EOF

echo -n "Please select an option:  "
read _my_choice

case "$_my_choice" in
 1) firstgen_cloudservers ;;
 2) nextgen_cloudservers ;;
 3) cloudblockstorage ;;
 4) cloudnetworks ;;
 5) cloudloadbalancers ;;
 6) modules/show_solution_overview.sh 
     echo ""
     echo "Press return key to continue..."
     read -p "$*"
     f_menu ;;
 9) exit ;;
 *) f_menu ;;
esac
}



firstgen_cloudservers() {

bold=`tput smso`
offbold=`tput rmso`
clear

cat << EOF

${bold}\
  Rackspace Cloud Admin Management Console  \
${offbold}\

  Account:  $OS_USERNAME ($OS_TENANT_NAME)


  1)  Create Server
  2)  Create Muliple Servers

  3)  List All Servers
  4)  List Server Details

  5)  Create Server Snapshot
  6)  List Server Snapshots
  7)  Delete Server Snapshots (Not working)
 
  8)  Reboot Server

  9)  Resize Server
  10) Confirm Server Resize
  11) Revert Resize

  12) Server Rebuild (Not working)
  13) Rescue Mode (Not working)
  14) Unrescue Mode (Not working)

  15) Reset Root Password
  16) Rename Server
  17) Delete Server

  18) List Available Images
  19) List Available Flavors
  20) List Account Limits (Not working)

  21) Return to main menu

EOF

echo -n "Please select an option:  "
read _my_choice

case "$_my_choice" in
 1)  modules/firstgen_cloudservers.sh --create-server  && firstgen_cloudservers ;;
 2)  modules/firstgen_cloudservers.sh --create-multiple-servers && firstgen_cloudservers ;;
 3)  clear
     echo "The following servers are setup on your account:"
     echo "" 
     modules/firstgen_cloudservers.sh --list-servers 
     echo ""
     echo "Press return key to continue..."
     read -p "$*"
     firstgen_cloudservers ;;
 4)  modules/firstgen_cloudservers.sh --list-server-details && firstgen_cloudservers ;;
 5)  modules/firstgen_cloudservers.sh --create-server-snapshot && firstgen_cloudservers ;;
 6)  modules/firstgen_cloudservers.sh --list-server-snapshots && firstgen_cloudservers ;;
 7)  modules/firstgen_cloudservers.sh --delete-server-snapshot && firstgen_cloudservers ;;
 8)  modules/firstgen_cloudservers.sh --server-reboot && firstgen_cloudservers ;;
 9)  modules/firstgen_cloudservers.sh --resize-server && firstgen_cloudservers ;;
 10) modules/firstgen_cloudservers.sh --resize-confirm && firstgen_cloudservers ;;
 11) modules/firstgen_cloudservers.sh --resize-revert && firstgen_cloudservers ;;
 12) modules/firstgen_cloudservers.sh --server-rebuild && firstgen_cloudservers ;;
 13) modules/firstgen_cloudservers.sh --rescue-mode && firstgen_cloudservers ;;
 14) modules/firstgen_cloudservers.sh --unrescue-mode && firstgen_cloudservers ;;
 15) modules/firstgen_cloudservers.sh --reset-password && firstgen_cloudservers ;;
 16) modules/firstgen_cloudservers.sh --rename-server && firstgen_cloudservers ;;
 17) modules/firstgen_cloudservers.sh --delete-server && firstgen_cloudservers ;;
 18) clear
     modules/firstgen_cloudservers.sh --image-list 
     echo "Press return key to continue..."
     read -p "$*"
     firstgen_cloudservers ;;
 19) clear
     modules/firstgen_cloudservers.sh --flavor-list 
     echo "Press return key to continue..."
     read -p "$*"
     firstgen_cloudservers ;;
 20) modules/firstgen_cloudservers.sh --absolute-limits && firstgen_cloudservers ;;
 21) f_menu ;; 
 *)  firstgen_cloudservers ;;
esac
}


nextgen_cloudservers() {

bold=`tput smso`
offbold=`tput rmso`
clear

cat << EOF

${bold}\
  Rackspace Cloud Admin Management Console  \
${offbold}\

  Account:  $OS_USERNAME ($OS_TENANT_NAME)


  1)  Create Server
  2)  Create Muliple Servers

  3)  List All Servers
  4)  List Server Details

  5)  Create Server Snapshot
  6)  List Server Snapshots
  7)  Delete Server Snapshots (Not working)
 
  8)  Reboot Server

  9)  Resize Server
  10) Confirm Server Resize
  11) Revert Resize

  12) Server Rebuild
  13) Rescue Mode
  14) Unrescue Mode

  15) Reset Root Password
  16) Rename Server
  17) Delete Server

  18) List Available Images
  19) List Available Flavors
  20) List Account Limits

  21) Return to main menu

EOF

echo -n "Please select an option:  "
read _my_choice

case "$_my_choice" in
 1)  modules/nextgen_cloudservers.sh --create-server  && nextgen_cloudservers ;;
 2)  modules/nextgen_cloudservers.sh --create-multiple-servers && nextgen_cloudservers ;;
 3)  clear
     echo "The following servers are setup on your account:"
     echo "" 
     modules/nextgen_cloudservers.sh --list-servers 
     echo ""
     echo "Press return key to continue..."
     read -p "$*"
     nextgen_cloudservers ;;
 4)  modules/nextgen_cloudservers.sh --list-server-details && nextgen_cloudservers ;;
 5)  modules/nextgen_cloudservers.sh --create-server-snapshot && nextgen_cloudservers ;;
 6)  modules/nextgen_cloudservers.sh --list-server-snapshots && nextgen_cloudservers ;;
 7)  modules/nextgen_cloudservers.sh --delete-server-snapshot && nextgen_cloudservers ;;
 8)  modules/nextgen_cloudservers.sh --server-reboot && nextgen_cloudservers ;;
 9)  modules/nextgen_cloudservers.sh --resize-server && nextgen_cloudservers ;;
 10) modules/nextgen_cloudservers.sh --resize-confirm && nextgen_cloudservers ;;
 11) modules/nextgen_cloudservers.sh --resize-revert && nextgen_cloudservers ;;
 12) modules/nextgen_cloudservers.sh --server-rebuild && nextgen_cloudservers ;;
 13) modules/nextgen_cloudservers.sh --rescue-mode && nextgen_cloudservers ;;
 14) modules/nextgen_cloudservers.sh --unrescue-mode && nextgen_cloudservers ;;
 15) modules/nextgen_cloudservers.sh --reset-password && nextgen_cloudservers ;;
 16) modules/nextgen_cloudservers.sh --rename-server && nextgen_cloudservers ;;
 17) modules/nextgen_cloudservers.sh --delete-server && nextgen_cloudservers ;;
 18) clear
     modules/nextgen_cloudservers.sh --image-list 
     echo "Press return key to continue..."
     read -p "$*"
     nextgen_cloudservers ;;
 19) clear
     modules/nextgen_cloudservers.sh --flavor-list 
     echo "Press return key to continue..."
     read -p "$*"
     nextgen_cloudservers ;;
 20) modules/nextgen_cloudservers.sh --absolute-limits && nextgen_cloudservers ;;
 21) f_menu ;; 
 *)  nextgen_cloudservers ;;
esac
}


cloudblockstorage() {

bold=`tput smso`
offbold=`tput rmso`
clear

cat << EOF

${bold}\
  Rackspace Cloud Admin Management Console  \
${offbold}\

  Account:  $OS_USERNAME ($OS_TENANT_NAME)


  1)  Create New Volume
  2)  Create New Volume From Snapshot
  3)  List All Volumes
  4)  List Volume Details

  5)  Attach Volume
  6)  Detach Volume

  7)  Create Volume Snapshot
  8)  List All Volume Snapshots
  9)  List Volume Snapshot Details
  10) Delete Volume Snapshot

  11) Delete Volume

  12) Return to main menu

EOF

echo -n "Please select an option:  "
read _my_choice

case "$_my_choice" in
 1) modules/cloudblockstorage.sh --create-volume && cloudblockstorage ;;
 2) modules/cloudblockstorage.sh --create-volume-from-snapshot && cloudblockstorage;;
 3) clear
    modules/cloudblockstorage.sh --volume-list
    echo "Press return key to continue..."
    read -p "$*"
    cloudblockstorage ;;
 4) modules/cloudblockstorage.sh --volume-details && cloudblockstorage ;; 
 5) modules/cloudblockstorage.sh --volume-attach && cloudblockstorage ;;
 6) modules/cloudblockstorage.sh --volume-detach && cloudblockstorage ;;
 7) modules/cloudblockstorage.sh --volume-snapshot-create && cloudblockstorage ;;
 8) clear
    modules/cloudblockstorage.sh --volume-snapshot-list 
    echo "Press return key to continue..."
    read -p "$*"
    cloudblockstorage ;;
 9) modules/cloudblockstorage.sh --volume-snapshot-show && cloudblockstorage ;;
 10) modules/cloudblockstorage.sh --volume-snapshot-delete && cloudblockstorage ;;
 11) modules/cloudblockstorage.sh --volume-delete && cloudblockstorage ;;
 12) f_menu ;;
 *) cloudblockstorage ;;
esac
}


cloudnetworks() {

bold=`tput smso`
offbold=`tput rmso`
clear

cat << EOF

${bold}\
  Rackspace Cloud Admin Management Console  \
${offbold}\

  Account:  $OS_USERNAME ($OS_TENANT_NAME)


  1)  Create Network 
  2)  List All Networks
  3)  List Network Details
  4)  List Servers Attached Networks

  5)  Attach Network
  6)  Detach Network

  7)  Delete Network

  8)  Return to main menu

EOF

echo -n "Please select an option:  "
read _my_choice

case "$_my_choice" in
 1) modules/cloudnetworks.sh --create-network && cloudnetworks ;;
 2) clear
    modules/cloudnetworks.sh --network-list
    echo "Press return key to continue..."
    read -p "$*"
    cloudnetworks ;;
 3) modules/cloudnetworks.sh --network-details && cloudnetworks ;;
 4) modules/cloudnetworks.sh --server-network-list && cloudnetworks ;;
 5) modules/cloudnetworks.sh --network-attach && cloudnetworks ;;
 6) modules/cloudnetworks.sh --network-detach && cloudnetworks ;;
 7) modules/cloudnetworks.sh --network-delete && cloudnetworks ;;
 8) f_menu ;;
 *) cloudnetworks ;;
esac
}


cloudloadbalancers() {

bold=`tput smso`
offbold=`tput rmso`
clear

cat << EOF

${bold}\
  Rackspace Cloud Admin Management Console  \
${offbold}\

  Account:  $OS_USERNAME ($OS_TENANT_NAME)


  1)  Create Cloud Load Balancer
  2)  List All Cloud Load Balancers
  3)  List Cloud Load Balancer Details

  4)  Add servers
  5)  Disable servers
  6)  Remove servers

  7)  Enable Session Persistence
  8)  Disable Session Persistence

  9)  Enable Logging
  10) Disable Logging

  11) Change Port/Protocol
  12) Change Algorithm
  13) Rename Cloud Load Balancer

  14) Show Current Health Check 
  15) Enable TCP Connect Health Check
  16) Enable HTTP Health Check
  17) Enable HTTPS Health Check
  18) Delete Health Check

  19) Show Current ACL's
  20) Add ACL
  21) Remove single ACL
  22) Clear all ACL's

  --) Enable SSL Termination
  --) Disable SSL Termination

  23) Show Stats
  24) Show Current Usage
  25) Show All Usage
  26) Show Error Page

  27) Delete Cloud Load Balancer

  28) Return to main menu

EOF

echo -n "Please select an option:  "
read _my_choice

case "$_my_choice" in
 1) modules/cloudloadbalancers.sh --create-lb && cloudloadbalancers ;;
 2) clear
    modules/cloudloadbalancers.sh --lb-list
    echo "Press return key to continue..."
    read -p "$*"
    cloudloadbalancers ;;
 3) modules/cloudloadbalancers.sh --lb-details && cloudloadbalancers ;;
 4) modules/cloudloadbalancers.sh --lb-add-nodes && cloudloadbalancers ;;
 5) modules/cloudloadbalancers.sh --lb-disable-nodes && cloudloadbalancers ;;
 6) modules/cloudloadbalancers.sh --lb-remove-nodes && cloudloadbalancers ;;
 7) modules/cloudloadbalancers.sh --lb-enable-persistence && cloudloadbalancers ;;
 8) modules/cloudloadbalancers.sh --lb-disable-persistence && cloudloadbalancers ;;
 9) modules/cloudloadbalancers.sh --lb-enable-logging && cloudloadbalancers ;;
 10) modules/cloudloadbalancers.sh --lb-disable-logging && cloudloadbalancers ;;
 11) modules/cloudloadbalancers.sh --lb-change-port-protocol && cloudloadbalancers ;;
 12) modules/cloudloadbalancers.sh --lb-change-algorithm && cloudloadbalancers ;;
 13) modules/cloudloadbalancers.sh --lb-rename && cloudloadbalancers ;;
 14) modules/cloudloadbalancers.sh --lb-show-monitor && cloudloadbalancers ;;
 15) modules/cloudloadbalancers.sh --lb-enable-tcp-connect-monitor && cloudloadbalancers ;;
 16) modules/cloudloadbalancers.sh --lb-enable-http-monitor && cloudloadbalancers ;;
 17) modules/cloudloadbalancers.sh --lb-enable-https-monitor && cloudloadbalancers ;;
 18) modules/cloudloadbalancers.sh --lb-delete-health-monitor && cloudloadbalancers ;;
 19) modules/cloudloadbalancers.sh --lb-details && cloudloadbalancers ;;
 20) modules/cloudloadbalancers.sh --lb-add-acl && cloudloadbalancers ;;
 21) modules/cloudloadbalancers.sh --lb-remove-acl && cloudloadbalancers ;;
 22) modules/cloudloadbalancers.sh --lb-clear-acl && cloudloadbalancers ;;
 23) modules/cloudloadbalancers.sh --lb-stats && cloudloadbalancers ;;
 24) modules/cloudloadbalancers.sh --lb-current-usage && cloudloadbalancers ;;
 25) modules/cloudloadbalancers.sh --lb-all-usage && cloudloadbalancers ;;
 26) modules/cloudloadbalancers.sh --lb-show-errorpage && cloudloadbalancers ;;
 27) modules/cloudloadbalancers.sh --lb-delete && cloudloadbalancers ;;
 28) f_menu ;;
 *) cloudloadbalancers ;;
esac
}


setup_auth() {

# Unset any previous set variables
unset OPENSTACK_COMPUTE_USERNAME OPENSTACK_COMPUTE_APIKEY OS_PASSWORD OS_USERNAME \
NOVA_USERNAME NOVA_PROJECT_ID CLOUD_LOADBALANCERS_USERNAME CLOUD_LOADBALANCERS_API_KEY \
CLOUD_LOADBALANCERS_REGION

# Prompt for new credentials
echo -n "Please enter your Cloud Username:  "
read user
echo -n "Please enter your Cloud API Key:  "
read apikey
echo -n "Please enter your account number:  "
read entity

# Generate config
cat << EOF > ~/.rscloudadmin

# FirstGen Cloud Servers:
OPENSTACK_COMPUTE_USERNAME=$user
OPENSTACK_COMPUTE_APIKEY=$apikey
export OPENSTACK_COMPUTE_USERNAME OPENSTACK_COMPUTE_APIKEY

# NextGen Cloud Servers:
OS_USERNAME=$user
OS_PASSWORD=$apikey
NOVA_USERNAME=$user
NOVA_PROJECT_ID=$entity
NOVA_SERVICE_NAME=cloudServersOpenStack
NOVA_URL=https://identity.api.rackspacecloud.com/v2.0/
NOVA_VERSION=1.1
NOVA_RAX_AUTH=1
OS_TENANT_NAME=$entity
OS_AUTH_URL=https://identity.api.rackspacecloud.com/v2.0/
OS_AUTH_SYSTEM=rackspace
OS_NO_CACHE=1
export OS_USERNAME OS_PASSWORD NOVA_USERNAME NOVA_PROJECT_ID NOVA_SERVICE_NAME \
NOVA_URL NOVA_VERSION NOVA_RAX_AUTH OS_TENANT_NAME OS_AUTH_URL OS_NO_CACHE \
OS_AUTH_SYSTEM

# Cloud Load Balancers
CLOUD_LOADBALANCERS_USERNAME=$user
CLOUD_LOADBALANCERS_API_KEY=$apikey
export CLOUD_LOADBALANCERS_USERNAME CLOUD_LOADBALANCERS_API_KEY
EOF
source ~/.rscloudadmin
f_menu

}

if [ ! -f ~/.rscloudadmin ]; then
	setup_auth
else
        user=`cat ~/.rscloudadmin |grep OS_USERNAME |grep -v export | cut -d\= -f2`
        account=`cat ~/.rscloudadmin |grep OS_TENANT_NAME |grep -v export | cut -d\= -f2`
        echo "Auth has already been set for $user ($account).  Would"
        echo "you like to continue to use this account?"

        echo -n "Type y / n:  "
        read answer
        if [ $answer = 'y' ]; then
        	source ~/.rscloudadmin && f_menu
	else
		setup_auth 
	fi
fi

