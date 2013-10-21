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


function get_region {

echo "Please choose a region:"
echo ""
echo "1.  DFW"
echo "2.  ORD"
echo "3.  SYD"
echo "4.  IAD"
echo --
echo ""
echo -n "Type the number of your selection:  "
echo ""
read region

if [ $region = 1 ]; then
        vm_region=DFW
elif [ $region = 2 ]; then
        vm_region=ORD
elif [ $region = 3 ]; then
        vm_region=SYD
elif [ $region = 4 ]; then
	vm_region=IAD
else
        echo "Invalid response.  Please try again."
        sleep 2
        exit
fi

}

function image_list {

get_region
nova --os-region-name $vm_region image-list 

}

function flavor_list {

nova --os-region-name ORD flavor-list

}

function list_servers {

regions=(DFW ORD SYD IAD)

for i in ${regions[@]}; do
echo "======================================== Region $i - NextGen ========================================"
echo ""
nova --os-region-name $i list
echo ""
echo "";
done
}

function get_server_id {

> serverlist.out
list_servers |while read servers; do x=$((x+1)); echo $x. $servers >> serverlist.out && echo $x.  $servers;
done
echo ""
echo -n "Type the number of your selection:  "
read selection

# Check to see if selection was valid
if [ `cat serverlist.out  |grep -c ^$selection` -eq 0 ]; then
        echo "You selected an invalid option"
        sleep 2
        exit
fi

# Get region
vm_region=`cat serverlist.out | egrep "^$selection\." | awk -FRegion\: '{print $2}'`

# Get ID and show server details
findserver=`cat serverlist.out | egrep "^$selection\." | awk '{print $2}'`
server_id=`nova --os-region-name $vm_region list |grep $findserver | awk '{print $2}'`
rm -f serverlist.out

}


function create_server_snapshot {

clear
echo "Which server would you to take an image of?"
echo ""
list_servers
echo ""
echo "Please enter the server's id:  "
read id
echo ""
echo -n "Please type a name for this image:  "
read name
if [ -z "$name" ]; then
        echo "Error:  Nothing was defined.  Please try again."
        sleep 2
        exit
fi
nova image-create $id $name
echo "Press return key to continue..."
read -p "$*"

}

function list_server_snapshots {

clear
echo "Which server would you like to display the snapshots for?"
echo ""
list_servers
echo ""
echo "Please enter the server's id:  "
read id
echo ""
echo "+--------------------------------------+----------------------------------------------------------------------------------+--------+--------------------------------------+"
echo "| ID                                   | Name                                                                             | Status | Server                               |"
echo "+--------------------------------------+----------------------------------------------------------------------------------+--------+--------------------------------------+"
nova image-list | grep $id
echo "+--------------------------------------+----------------------------------------------------------------------------------+--------+--------------------------------------+"
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function delete_server_snapshot {

echo "Not working yet"
sleep 2

}

function create_server {

clear
echo -n "Please type servers hostname:  "
read hostname
if [ -z "$hostname" ]; then
	echo "Error:  Nothing was defined.  Please try again."
	sleep 2
        exit
fi

echo ""
get_region

echo ""
echo "What image would you like to use?"
echo ""
nova --os-region-name $vm_region image-list
echo ""
echo -n "Type the ID of the image:  "
read image

if [ -z "$image" ]; then
        echo "Error:  Nothing was defined.  Please try again."
        sleep 2
        exit
fi

# Check to see if selection was valid
#if [ `cat imagelist.out  |grep -c ^$imagetmp` -eq 0 ]; then
#        echo "You selected an invalid option"
#        sleep 2
#        exit
#fi

echo ""
echo "What flavor would you like to use?"
echo ""
nova --os-region-name $vm_region flavor-list
echo ""
echo -n "Type the ID of the flavor:  "
read flavor
if [ -z "$flavor" ]; then
        echo "Error:  Nothing was defined.  Please try again."
        sleep 2
        exit
fi

nova --os-region-name $vm_region boot --flavor $flavor --image $image $hostname
echo "Press return key to continue..."
read -p "$*"

}


function create_multiple_servers {

echo -n "How many servers would you like to build:  "
read number
echo -n "What prefix do you want on the hostnames?  (ie.  web, db, mail, server):  "
read prefix
echo ""
get_region

echo ""
echo "What image would you like to use?"
echo ""
nova --os-region-name $vm_region image-list
echo ""
echo -n "Type the ID of the image:  "
read image

if [ -z "$image" ]; then
        echo "Error:  Nothing was defined.  Please try again."
        sleep 2
        exit
fi

# Check to see if selection was valid
#if [ `cat imagelist.out  |grep -c ^$imagetmp` -eq 0 ]; then
#        echo "You selected an invalid option"
#        sleep 2
#        exit
#fi

echo ""
echo "What flavor would you like to use?"
echo ""
nova --os-region-name $vm_region flavor-list
echo ""
echo -n "Type the ID of the flavor:  "
read flavor
if [ -z "$flavor" ]; then
        echo "Error:  Nothing was defined.  Please try again."
        sleep 2
        exit
fi

# Begin loop to create all the servers

count=1
servernumber=1
while [ $count -le $number ]; do
nova --os-region-name $vm_region boot --flavor $flavor --image $image $prefix$servernumber
count=$(( $count + 1 ))
servernumber=$(( $servernumber + 1))
done

echo "Press return key to continue..."
read -p "$*"

}



function list_server_details {

clear
echo "Which server would you like more detail on?"
echo ""
list_servers
echo -n "Type the ID of the server:  "
read server_id
get_region
nova --os-region-name $vm_region show $server_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function server_reboot {

clear
echo "Which server would you like to reboot?"
echo ""
list_servers
echo ""
echo -n "Type the ID of the server:  "
read server_id
get_region
nova --os-region-name $vm_region reboot --hard $server_id
echo "Press return key to continue..."
read -p "$*"

}

function resize_server {

clear
echo "Which server would you like to resize?"
echo ""
list_servers
echo ""
echo -n "Type the ID of the server:  "
read server_id
get_region
echo ""
echo "What would you like to resize the server to?"
echo ""
nova --os-region-name $vm_region flavor-list
echo ""
echo -n "Type the ID of your selection:  "
read input
nova --os-region-name $vm_region resize $server_id $input
echo "Press return key to continue..."
read -p "$*"

}

function resize_confirm {

clear
echo "Which server would you like to confirm the resize on?"
echo ""
list_servers
echo ""
echo -n "Type the ID of the server:  "
read server_id
get_region
nova --os-region-name $vm_region resize_confirm $server_id
echo "Press return key to continue..."
read -p "$*"

}

function resize_revert {

clear
echo "Which server would you like to revert the resize on?"
echo ""
list_servers
echo ""
echo -n "Type the ID of the server:  "
read server_id
get_region
nova --os-region-name $vm_region resize-revert $server_id
echo "Press return key to continue..."
read -p "$*"

}

function server_rebuild {

echo "Not working yet"

}

function reset_password {

clear
echo "Which server would you like to reset the root password for?"
echo ""
list_servers
echo ""
echo -n "Type the ID of the server:  "
read server_id
get_region
nova --os-region-name $vm_region root-password $server_id
echo "Press return key to continue..."
read -p "$*"

}

function rename_server {

clear
echo "Which server would you like to rename?"
echo ""
list_servers
echo ""
echo -n "Type the ID of the server:  "
read server_id
get_region
echo ""
echo -n "Type the new name for the server:  "
read input
nova --os-region-name $vm_region rename $server_id $input
echo "Press return key to continue..."
read -p "$*"

}

function rescue_mode {

clear
echo "Which server would you like to put into rescue mode?"
echo ""
list_servers
echo ""
echo -n "Type the ID of the server:  "
read server_id
get_region
nova --os-region-name $vm_region rescue $server_id
echo "Press return key to continue..."
read -p "$*"

}

function unrescue_mode {

clear
echo "Which server would you like to take out of rescue mode?"
echo ""
list_servers
echo ""
echo -n "Type the ID of the server:  "
read server_id
get_region
nova --os-region-name $vm_region unrescue $server_id
echo "Press return key to continue..."
read -p "$*"

}

function delete_server {

clear
echo "Which server would you like to delete?"
echo ""
list_servers
echo ""
echo -n "Type the ID of the server:  "
read server_id
get_region
nova --os-region-name $vm_region delete $server_id
echo "Press return key to continue..."
read -p "$*"
}

function absolute_limits {

clear
get_region
nova --os-region-name $vm_region absolute-limits
echo "Press return key to continue..."
read -p "$*"

}


# Main

case "$1" in
--help) help;;
--image-list) image_list;;
--flavor-list) flavor_list;;
--list-servers) list_servers;;
--get-server-id) get_server_id;;
--create-server) create_server;;
--create-multiple-servers) create_multiple_servers;;
--list-server-details) list_server_details;;
--create-server-snapshot) create_server_snapshot;;
--list-server-snapshots) list_server_snapshots;;
--delete-server-snapshot) delete_server_snapshot;;
--server-reboot) server_reboot;;
--resize-server) resize_server;;
--resize-confirm) resize_confirm;;
--resize-revert) resize_revert;;
--server-rebuild) server_rebuild;;
--reset-password) reset_password;;
--rename-server) rename_server;;
--rescue-mode) rescue_mode;;
--unrescue-mode) unrescue_mode;;
--delete-server) delete_server;;
--absolute-limits) absolute_limits;; 
*) exit ;;
esac
