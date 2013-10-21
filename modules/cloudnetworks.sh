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

function network_list {

regions=(DFW ORD SYD IAD)

for i in ${regions[@]}; do
echo "======================================== Region $i - Networks ========================================"
echo ""
nova --os-region-name $i network-list 
echo ""
echo "";
done

}

function network_details {

clear
echo -n "Which network would you like more detail on?"
echo ""
echo ""
network_list
echo ""
echo -n "Type the ID of the network:  "
read network_id
echo ""
get_region
echo ""
nova --os-region-name $vm_region network $network_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function create_network {

clear
echo -n "Please enter a name for this volume:  "
read name
if [ -z "$name" ]; then
        echo "Error:  Nothing was defined.  Please try again."
        sleep 2
        exit
fi
echo ""
echo -n "Please type a cidr to use:  Ex. 192.168.200.0/24:  "
read cidr
echo ""
get_region
echo ""
nova --os-region-name $vm_region network-create $name $cidr
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function network_attach {

clear
echo "Please select server you want to attach new network to:"
list_servers
echo ""
echo -n "Type the ID of the server:  "
read server_id
echo ""
get_region
echo ""
echo -n "Please select which network you want to attach:"
echo ""
network_list
echo ""
echo -n "Type the ID of the network:  "
read network_id
echo ""
nova --os-region-name $vm_region virtual-interface-create $network_id $server_id
echo "Press return key to continue..."
read -p "$*"

}

function network_detach {

clear
echo "Please select server you want to detach the network from:"
echo ""
list_servers
echo -n "Type the ID of the server:  "
read server_id
echo ""
get_region
echo ""
echo "Please select which network you want to detach:"
echo ""
network_list
echo -n "Type the ID of the network:  "
read network_id
echo ""
nova --os-region-name $vm_region virtual-interface-delete $server_id $network_id
echo "Press return key to continue..."
read -p "$*"

}

function network_delete {

clear
echo "Please select which network you want to delete:"
echo ""
network_list
echo ""
echo -n "Type the ID of the network:  "
read network_id
echo ""
get_region
echo ""
nova --os-region-name $vm_region network-delete $network_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function server_network_list {

clear
echo "Please select server you want to view the available networks on:"
echo ""
list_servers
echo ""
echo -n "Type the ID of the server:  "
read server_id
echo ""
get_region
echo ""
nova --os-region-name $vm_region virtual-interface-list $server_id
echo "Press return key to continue..."
read -p "$*"

}


# Main

case "$1" in
--help) help;;
--network-list) network_list;;
--list-servers) list_servers;;
--network-details) network_details;;
--create-network) create_network;;
--network-attach) network_attach;;
--network-detach) network_detach;;
--network-delete) network_delete;;
--server-network-list) server_network_list;;
*) exit ;;
esac
