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

function volume_list {

regions=(DFW ORD SYD IAD)

for i in ${regions[@]}; do
echo "======================================== Region $i - Volumes ========================================"
echo ""
nova --os-region-name $i volume-list 
echo ""
echo "";
done

}

function volume_details {

clear
echo -n "Which volume would you like more detail on?"
echo ""
echo ""
volume_list
echo ""
echo -n "Type the ID of the volume:  "
read volume_id
echo ""
get_region
echo ""
nova --os-region-name $vm_region volume-show $volume_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function create_volume {

clear
echo -n "Please enter a name for this volume:  "
read name
if [ -z "$name" ]; then
        echo "Error:  Nothing was defined.  Please try again."
        sleep 2
        exit
fi
echo ""
echo -n "Choose volume type"
echo ""
echo "1.  Sata"
echo "2.  SSD"
echo ""
echo -n "Type your selection here:  "
read selection

if [ $selection = "1" ]; then
	type=sata
elif [ $selection = "2" ]; then
	type=ssd
else
	echo "Please type 1 or 2"
	echo "sleep 2"
	exit
fi
echo ""
echo "Please enter in a volume size in G.  Minimum size"
echo "is 100G.  Maximum size is 1024G.  Example:  100"
echo -n "Enter volume size:  "
read size
if [ -z "$size" ]; then
        echo "Error:  Nothing was defined.  Please try again."
        sleep 2
        exit
fi
echo ""
get_region
echo ""
nova --os-region-name $vm_region volume-create --display-name=$name --volume-type=$type $size
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function create_volume_from_snapshot {

clear
echo "Which volume snapshot would you build a new volume from?"
echo ""
volume_snapshot_list
echo ""
echo -n "Type the ID of the volume snapshot:  "
read volume_snapshot_id
echo ""
echo -n "Type the size of the volume snapshot displayed above:  "
read volume_size
echo ""
echo -n "Please enter a name for this volume:  "
read name
if [ -z "$name" ]; then
        echo "Error:  Nothing was defined.  Please try again."
        sleep 2
        exit
fi
echo ""
echo -n "Choose volume type"
echo ""
echo "1.  Sata"
echo "2.  SSD"
echo ""
echo -n "Type your selection here:  "
read selection

if [ $selection = "1" ]; then
        type=sata
elif [ $selection = "2" ]; then
        type=ssd
else
        echo "Please type 1 or 2"
        echo "sleep 2"
        exit
fi
echo ""
get_region
echo ""
nova --os-region-name $vm_region volume-create --display-name=$name --snapshot-id=$volume_snapshot_id --volume-type=$type $volume_size
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function volume_attach {

clear
echo "Please select server you want to attach new volume to:"
list_servers
echo ""
echo -n "Type the ID of the server:  "
read $server_id
echo ""
get_region
echo ""
echo -n "Please select which volume you want to attach:"
echo ""
volume_list
echo ""
echo -n "Type the ID of the volume:  "
read volume_id
echo ""
nova --os-region-name $vm_region volume-attach $server_id $volume_id
echo "Press return key to continue..."
read -p "$*"

}

function volume_detach {

clear
echo "Please select server you want to detach the volume from:"
echo ""
list_servers
echo ""
get_region
echo ""
echo -n "Type the ID of the server:  "
echo ""
echo "Please select which volume you want to detach:"
echo ""
volume_list
echo -n "Type the ID of the volume:  "
echo ""
nova --os-region-name $vm_region volume-detach $server_id $volume_id
echo "Press return key to continue..."
read -p "$*"

}

function volume_delete {

clear
echo "Please select which volume you want to delete:"
echo ""
volume_list
echo ""
echo -n "Type the ID of the volume:  "
read volume_id
echo ""
get_region
echo ""
nova --os-region-name $vm_region volume-delete $volume_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function volume_snapshot_create {

clear
echo "Please select which volume you want to snapshot:"
echo ""
volume_list
echo ""
echo -n "Type the ID of the volume:  "
read volume_id
echo ""
get_region
echo ""
echo -n "Please type a name for this snapshot: "
read snapshot_name
echo ""
nova --os-region-name $vm_region volume-snapshot-create --display-name $snapshot_name $volume_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function volume_snapshot_list {

regions=(DFW ORD SYD IAD)

for i in ${regions[@]}; do
echo "======================================== Region $i - Volume Snapshots ========================================"
echo ""
nova --os-region-name $i volume-snapshot-list
echo ""
echo "";
done

}

function volume_snapshot_show {

clear
echo -n "Which volume snapshot would you like more detail on?"
echo ""
echo ""
volume_snapshot_list
echo ""
echo -n "Type the ID of the volume snapshot:  "
read volume_snapshot_id
echo ""
get_region
echo ""
nova --os-region-name $vm_region volume-snapshot-show $volume_snapshot_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function volume_snapshot_delete {

clear
echo "Please select which volume snapshot you want to delete:"
echo ""
volume_snapshot_list
echo ""
echo -n "Type the ID of the volume snapshot:  "
read volume_snapshot_id
echo ""
get_region
echo ""
nova --os-region-name $vm_region volume-snapshot-delete $volume_snapshot_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}


# Main

case "$1" in
--help) help;;
--volume-list) volume_list;;
--get-volume-id) get_volume_id;;
--list-servers) list_servers;;
--volume-details) volume_details;;
--create-volume) create_volume;;
--volume-attach) volume_attach;;
--volume-detach) volume_detach;;
--volume-delete) volume_delete;;
--volume-snapshot-create) volume_snapshot_create;;
--create-volume-from-snapshot) create_volume_from_snapshot;;
--volume-snapshot-list) volume_snapshot_list;;
--volume-snapshot-show) volume_snapshot_show;;
--volume-snapshot-delete) volume_snapshot_delete;;
*) exit ;;
esac
