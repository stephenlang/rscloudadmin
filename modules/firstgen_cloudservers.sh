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


function image_list {

openstack-compute image-list

}

function flavor_list {

openstack-compute flavor-list

}

function list_servers {

openstack-compute list

}

function create_server_snapshot {

clear
echo "Which server would you to take an image of?"
echo ""
list_servers
echo ""
echo -n "Please enter the server's id:  "
read id
echo ""
echo -n "Please type a name for this image:  "
read name
if [ -z "$name" ]; then
        echo "Error:  Nothing was defined.  Please try again."
        sleep 2
        exit
fi
openstack-compute image-create $id $name
echo "Press return key to continue..."
read -p "$*"

}

function list_server_snapshots {

clear
echo ""
openstack-compute image-list
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
echo "What image would you like to use?"
echo ""
openstack-compute image-list
echo ""
echo -n "Type the ID of the image:  "
read image

if [ -z "$image" ]; then
        echo "Error:  Nothing was defined.  Please try again."
        sleep 2
        exit
fi

echo ""
echo "What flavor would you like to use?"
echo ""
openstack-compute flavor-list
echo ""
echo -n "Type the ID of the flavor:  "
read flavor
if [ -z "$flavor" ]; then
        echo "Error:  Nothing was defined.  Please try again."
        sleep 2
        exit
fi

openstack-compute boot --flavor $flavor --image $image $hostname
echo "Press return key to continue..."
read -p "$*"

}


function create_multiple_servers {

echo -n "How many servers would you like to build:  "
read number
echo -n "What prefix do you want on the hostnames?  (ie.  web, db, mail, server):  "
read prefix
echo ""
echo "What image would you like to use?"
echo ""
openstack-compute image-list
echo ""
echo -n "Type the ID of the image:  "
read image

if [ -z "$image" ]; then
        echo "Error:  Nothing was defined.  Please try again."
        sleep 2
        exit
fi

echo ""
echo "What flavor would you like to use?"
echo ""
openstack-compute flavor-list
echo ""
echo -n "Type the ID of the flavor:  "
read flavor
if [ -z "$flavor" ]; then
        echo "Error:  Nothing was defined.  Please try again."
        sleep 2
        exit
fi
echo ""

# Begin loop to create all the servers

count=1
servernumber=1
while [ $count -le $number ]; do
openstack-compute boot --flavor $flavor --image $image $prefix$servernumber
echo ""
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
echo ""
openstack-compute show $server_id
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
echo ""
openstack-compute reboot --hard $server_id
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
echo ""
echo "What would you like to resize the server to?"
echo ""
openstack-compute flavor-list
echo ""
echo -n "Type the ID of your selection:  "
read input
openstack-compute resize $server_id $input
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
echo ""
openstack-compute resize-confirm $server_id
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
echo ""
openstack-compute resize-revert $server_id
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
openstack-compute root-password $server_id
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
echo ""
echo -n "Type the new name for the server:  "
read input
echo ""
openstack-compute rename $server_id $input
echo "Press return key to continue..."
read -p "$*"

}

function rescue_mode {

clear
echo "Not available.  Please perform this through control panel."
#echo "Which server would you like to put into rescue mode?"
#echo ""
#list_servers
#echo ""
#echo -n "Type the ID of the server:  "
#read server_id
#openstack-compute rescue $server_id
echo "Press return key to continue..."
read -p "$*"

}

function unrescue_mode {

clear
echo "Not available.  Please perform this through control panel."
#echo "Which server would you like to take out of rescue mode?"
#echo ""
#list_servers
#echo ""
#echo -n "Type the ID of the server:  "
#read server_id
#openstack-compute unrescue $server_id
echo "Press return key to continue..."
read -p "$*"

}

function delete_server {

clear
echo "Which server would you like to delete?.  Warning, this executes"
echo "as soon as you select the server."
echo ""
list_servers
echo ""
echo -n "Type the ID of the server:  "
read server_id
openstack-compute delete $server_id
echo "Press return key to continue..."
read -p "$*"
}

function absolute_limits {

clear

echo "This option is not available yet."
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
