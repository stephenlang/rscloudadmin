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

function lb_list {

regions=(DFW ORD SYD IAD)

for i in ${regions[@]}; do
echo "=================================== Region $i - Cloud Load Balancers ==================================="
echo ""
clb --region $i list 
echo ""
echo "";
done

}

function lb_details {

clear
echo -n "Which Cloud Load Balancer would you like more detail on?"
echo ""
echo ""
lb_list
echo ""
echo -n "Type the ID of the Cloud Load Balancer:  "
read lb_id
echo ""
get_region
echo ""
clb --region $vm_region show $lb_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function create_lb {

clear
echo -n "Please enter a name for this Cloud Load Balancer:  "
read name
if [ -z "$name" ]; then
        echo "Error:  Nothing was defined.  Please try again."
        sleep 2
        exit
fi
echo ""
get_region
echo ""
clear
echo "Choose an algorithm:"
echo "This does not work!!!! FIX ME"
echo ""
clb --region $vm_region list-algorithms
echo ""
echo -n "Type your selection here:  "
read algorithm
echo ""
clear
echo "Choose protocol:"
echo ""
clb --region $vm_region list-protocols
echo ""
echo -n "Type your selection here:  "
read protocol
echo ""

echo -n "Type the port number for the protocol here:  "
read port
echo ""
clear
echo "Choose if this is a public facing load balancer, a servicenet load balancer, or"
echo "if you would like to share a VIP from an existing load balancer:"
echo ""
echo "1.  public"
echo "2.  servicenet"
echo "3.  share vip"
echo ""
echo -n "Type your selection here:  "
read selection

if [ $selection = "1" ]; then
        type=public
elif [ $selection = "2" ]; then
        type=servicenet
elif [ $selection = "3" ]; then
	echo ""
	echo "Please type the IP of the Load Balancer you would like to share the VIP against:"
	echo ""
	regions=(ORD DFW SYD IAD)
        for i in ${regions[@]}; do
	echo "=================================== Region $i - Cloud Load Balancer ==================================="
	echo ""
	clb --region $i list; done
	echo ""
	echo -n "Type the ID of the Cloud Load Balancer here:  "
	read type
else
        echo "Please type 1, 2, or 3"
        echo "sleep 2"
        exit
fi
echo ""
clear
echo -n "Which Cloud Server IP's would you like to add to the Cloud Load Balancer"
echo ""
regions=(ORD DFW SYD IAD)

for i in ${regions[@]}; do

echo "======================================== Region $i - NextGen ========================================"
echo ""
echo "Cloud Servers"
echo ""
nova --os-region-name $i list
echo ""; done

echo "======================================== First Gen ========================================"
echo ""
echo "Cloud Servers"
echo ""
openstack-compute list
echo ""
echo "Type the IP's of the Cloud Servers in the following format:"
echo "example:  10.1.1.1:80,10.1.1.2:80,10.1.1.3:80"
echo "Be sure to include the single quotes, commas, and no spaces"
echo ""
echo -n "Type your selection:  "
read cloudservers
echo ""
clb --region $vm_region create $name $port $protocol $cloudservers $type
echo ""
echo "Press return key to continue..."
read -p "$*"

}


function lb_stats  {

clear
echo "Please select Cloud Load Balancer to view the stats on:"
echo ""
lb_list
echo ""
echo -n "Type the ID of the Cloud Load Balancer:  "
read lb_id
get_region
echo ""
clb --region $vm_region show-stats $lb_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function lb_current_usage {

clear
echo "Please select Cloud Load Balancer to view current usage on:"
echo ""
lb_list
echo ""
echo -n "Type the ID of the Cloud Load Balancer:  "
read lb_id
echo ""
get_region
echo ""
clb --region $vm_region show-usage $lb_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function lb_all_usage {

clear
echo "Please select Cloud Load Balancer to view all usage on:"
echo ""
lb_list
echo ""
echo -n "Type the ID of the Cloud Load Balancer:  "
read lb_id
echo ""
get_region
echo ""
clb --region $vm_region show-all-usage $lb_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function lb_show_monitor {

clear
echo "Please select Cloud Load Balancer to show monitor on:"
echo ""
lb_list
echo ""
echo -n "Type the ID of the Cloud Load Balancer:  "
read lb_id
echo ""
get_region
echo ""
clb --region $vm_region show-monitor $lb_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function lb_enable_tcp_connect_monitor {

clear
echo "Please select Cloud Load Balancer to set TCP connect health check on:"
echo ""
lb_list
echo ""
echo -n "Type the ID of the Cloud Load Balancer:  "
read lb_id
echo ""
get_region
echo ""
echo "Choose delay value - The minimum number of seconds to wait before executing the health monitor."
echo "If unsure, 30 should be safe."
echo ""
echo -n "Enter seconds to set delay:  "
read delay
echo ""
echo "Choose timeout value - Maximum number of seconds to wait for a connection to be established"
echo "before timing out.  If unsure, 5 should be safe."
echo ""
echo -n "Enter seconds to set timeout:  "
read timeout
echo ""
echo "Choose attempts value - Number of permissible monitor failures before removing a node from"
echo "rotation.  If unsure, 3 should be safe."
echo ""
echo -n "Enter number of attempts:  "
read attempts
clb --region $vm_region set-monitor-connect $lb_id $delay $timeout $attempts
sleep 5
clb --region $vm_region show-monitor $lb_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function lb_enable_http_monitor {

clear
echo "Please select Cloud Load Balancer to set HTTP health check on:"
echo ""
lb_list
echo ""
echo -n "Type the ID of the Cloud Load Balancer:  "
read lb_id
echo ""
get_region
echo ""
echo "Choose delay value - The minimum number of seconds to wait before executing the health monitor."
echo "If unsure, 30 should be safe."
echo ""
echo -n "Enter seconds to set delay:  "
read delay
echo ""
echo "Choose timeout value - Maximum number of seconds to wait for a connection to be established"
echo "before timing out.  If unsure, 5 should be safe."
echo ""
echo -n "Enter seconds to set timeout:  "
read timeout
echo ""
echo "Choose attempts value - Number of permissible monitor failures before removing a node from"
echo "rotation.  If unsure, 3 should be safe."
echo ""
echo -n "Enter number of attempts:  "
read attempts
echo ""
echo "Type HTTP path that will be used to monitor request.  Example:  /test.php"
echo -n "Enter path to page:  "
read path
echo ""
echo "Choose content to search for on page.  Example:  OK"
echo "Type content:  "
read body
clb --region $vm_region set-monitor-http $lb_id $delay $timeout $attempts $path standard "$body"
sleep 5
clb --region $vm_region show-monitor $lb_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function lb_enable_https_monitor {

clear
echo "Please select Cloud Load Balancer to set HTTPS health check on:"
echo ""
lb_list
echo ""
echo -n "Type the ID of the Cloud Load Balancer:  "
read lb_id
echo ""
get_region
echo ""
echo "Choose delay value - The minimum number of seconds to wait before executing the health monitor."
echo "If unsure, 30 should be safe."
echo ""
echo -n "Enter seconds to set delay:  "
read delay
echo ""
echo "Choose timeout value - Maximum number of seconds to wait for a connection to be established"
echo "before timing out.  If unsure, 5 should be safe."
echo ""
echo -n "Enter seconds to set timeout:  "
read timeout
echo ""
echo "Choose attempts value - Number of permissible monitor failures before removing a node from"
echo "rotation.  If unsure, 3 should be safe."
echo ""
echo -n "Enter number of attempts:  "
read attempts
echo ""
echo "Type HTTP path that will be used to monitor request.  Example:  /test.php"
echo -n "Enter path to page:  "
read path
echo ""
echo "Choose content to search for on page.  Example:  OK"
echo "Type content:  "
read body
clb --region $vm_region set-monitor-https $lb_id $delay $timeout $attempts $path standard "$body"
sleep 5
clb --region $vm_region show-monitor $lb_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function lb_add_acl {

clear
echo "Please select Cloud Load Balancer to add an ACL on:"
echo ""
lb_list
echo ""
echo -n "Type the ID of the Cloud Load Balancer:  "
read lb_id
echo ""
get_region
echo ""
echo "Choose if you want to create an allow or deny ACL:"
echo ""
echo "1.  allow"
echo "2.  deny"
echo ""
echo -n "Type your selection here:  "
read selection

if [ $selection = "1" ]; then
        type=allow
elif [ $selection = "2" ]; then
        type=deny
else
        echo "Please type 1 or 2"
        echo "sleep 2"
        exit
fi
echo ""
echo -n "Type the IP (CIDR allowed) you wish to $type:  "
read ip
echo ""
clb --region $vm_region add-acls $lb_id $type $ip
echo ""
sleep 5
clb --region $vm_region show $lb_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function lb_remove_acl {

clear
echo "Please select Cloud Load Balancer to remove an ACL on:"
echo ""
lb_list
echo ""
echo -n "Type the ID of the Cloud Load Balancer:  "
read lb_id
echo ""
get_region
echo ""
echo "Chose which ACL you want to remove"
clb --region $vm_region show $lb_id
echo ""
echo "Type comma-delimited list of ACL ids:  "
read acl
echo ""
clb --region $vm_region remove-acls $lb_id $acl
echo ""
sleep 5
clb --region $vm_region show $lb_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function lb_clear_acl {

clear
echo "Please select Cloud Load Balancer to clear all ACL's on:"
echo ""
lb_list
echo ""
echo -n "Type the ID of the Cloud Load Balancer:  "
read lb_id
echo ""
get_region
echo ""
clb --region $vm_region clear-acls $lb_id
echo ""
sleep 5
clb --region $vm_region show $lb_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function lb_delete_health_monitor {

clear
echo "Please select Cloud Load Balancer to remove health monitor on:"
echo ""
lb_list
echo ""
echo -n "Type the ID of the Cloud Load Balancer:  "
read lb_id
echo ""
get_region
echo ""
clb --region $vm_region delete-monitor $lb_id
sleep 5
clb --region $vm_region show-monitor $lb_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function lb_show_errorpage {

clear
echo "Please select Cloud Load Balancer to view error page on:"
echo ""
lb_list
echo ""
echo -n "Type the ID of the Cloud Load Balancer:  "
read lb_id
echo ""
get_region
echo ""
clb --region $vm_region show-errorpage $lb_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function lb_enable_logging {

clear
echo "Please select Cloud Load Balancer to enable logging on:"
echo ""
lb_list
echo ""
echo -n "Type the ID of the Cloud Load Balancer:  "
read lb_id
echo ""
get_region
echo ""
clb --region $vm_region enable-logging $lb_id
sleep 5
clb --region $vm_region show $lb_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function lb_disable_logging {

clear
echo "Please select Cloud Load Balancer to disable logging on:"
echo ""
lb_list
echo ""
echo -n "Type the ID of the Cloud Load Balancer:  "
read lb_id
echo ""
get_region
echo ""
clb --region $vm_region disable-logging $lb_id
sleep 5
clb --region $vm_region show $lb_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function lb_enable_persistence {

clear
echo "Please select Cloud Load Balancer to enable persistence on:"
echo ""
lb_list
echo ""
echo -n "Type the ID of the Cloud Load Balancer:  "
read lb_id
echo ""
get_region
echo ""
clb --region $vm_region enable-persistence $lb_id
sleep 5
clb --region $vm_region show $lb_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function lb_disable_persistence {

clear
echo "Please select Cloud Load Balancer to disable persistence on:"
echo ""
lb_list
echo ""
echo -n "Type the ID of the Cloud Load Balancer:  "
read lb_id
echo ""
get_region
echo ""
clb --region $vm_region disable-persistence $lb_id
sleep 5
clb --region $vm_region show $lb_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function lb_delete {

clear
echo "Please select which Cloud Load Balancer you want to delete:"
echo ""
lb_list
echo ""
echo -n "Type the ID of the Cloud Load Balancer:  "
read lb_id
echo ""
get_region
echo ""
clb --region $vm_region delete $lb_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function lb_rename {

clear
echo "Please select Cloud Load Balancer you want to rename:"
echo ""
lb_list
echo ""
echo -n "Type the ID of the Cloud Load Balancer:  "
read lb_id
echo ""
get_region
echo ""
echo -n "Please type a new name for this Cloud Load Balancer: "
read lb_name
echo ""
clb --region $vm_region rename $lb_id $lb_name
sleep 5
clb --region $vm_region show $lb_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function lb_change_port_protocol {

clear
echo "Please select Cloud Load Balancer you want to change port and protocol on:"
echo ""
lb_list
echo ""
echo -n "Type the ID of the Cloud Load Balancer:  "
read lb_id
echo ""
get_region
echo ""
echo "Choose new protocol:"
echo ""
clb --region $vm_region list-protocols
echo ""
echo -n "Type your selection here:  "
read protocol
echo ""
echo -n "Type the port number for the protocol here:  "
read port
echo ""
clb --region $vm_region change-protocol $lb_id $protocol
sleep 5
clb --region $vm_region change-port $lb_id $port
sleep 5
clb --region $vm_region show $lb_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function lb_change_algorithm {

clear
echo "Please select Cloud Load Balancer you want to change algorithm on:"
echo ""
lb_list
echo ""
echo -n "Type the ID of the Cloud Load Balancer:  "
read lb_id
echo ""
get_region
echo ""
echo -n "Choose an algorithm:"
echo ""
clb --region $vm_region list-algorithms
echo ""
echo -n "Type your selection here:  "
read algorithm
echo ""
clb --region $vm_region change-algorithm $lb_id $algorithm 
sleep 5
clb --region $vm_region show $lb_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function lb_add_nodes {

clear
echo "Please select Cloud Load Balancer you want to add servers to:"
echo ""
lb_list
echo ""
echo -n "Type the ID of the Cloud Load Balancer:  "
read lb_id
echo ""
get_region
echo ""
echo "Currently, the following nodes are setup on the Cloud Load Balancer:"
clb --region $vm_region show $lb_id
echo ""
echo -n "Which Cloud Server IP's would you like to add to the Cloud Load Balancer"
echo ""
regions=(ORD DFW SYD IAD)

for i in ${regions[@]}; do

echo "======================================== Region $i - NextGen ========================================"
echo ""
echo "Cloud Servers"
echo ""
nova --os-region-name $i list
echo ""; done

echo "======================================== First Gen ========================================"
echo ""
echo "Cloud Servers"
echo ""
openstack-compute list
echo ""
echo "Type the IP's of the Cloud Servers in the following format:"
echo "example:  10.1.1.1:80,10.1.1.2:80,10.1.1.3:80"
echo "Be sure to include the single quotes, commas, and no spaces"
echo ""
echo -n "Type your selection:  "
read cloudservers
echo ""
clb --region $vm_region add-nodes $lb_id $cloudservers
sleep 5
clb --region $vm_region show $lb_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function lb_remove_nodes {

clear
echo "Please select Cloud Load Balancer you want to remove servers on:"
echo ""
lb_list
echo ""
echo -n "Type the ID of the Cloud Load Balancer:  "
read lb_id
echo ""
get_region
echo ""
echo "Currently, the following nodes are setup on the Cloud Load Balancer:"
clb --region $vm_region show $lb_id
echo ""
echo "Which Cloud Server IP's would you like to remove from the Cloud Load Balancer?"
echo ""
echo "Type the IP's of the Cloud Servers in the following format:"
echo "example:  10.1.1.1:80,10.1.1.2:80,10.1.1.3:80"
echo ""
echo "Be sure to include the single quotes, commas, and no spaces"
echo ""
echo -n "Type your selection:  "
read cloudservers
echo ""
clb --region $vm_region remove-nodes $lb_id $cloudservers
sleep 5
clb --region $vm_region show $lb_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}

function lb_disable_nodes {

clear
echo "Please select Cloud Load Balancer you want to disable servers on:"
echo ""
lb_list
echo ""
echo -n "Type the ID of the Cloud Load Balancer:  "
read lb_id
echo ""
get_region
echo ""
echo "Currently, the following nodes are setup on the Cloud Load Balancer:"
clb --region $vm_region show $lb_id
echo ""
echo "Which Cloud Server IP's would you like to disable on the Cloud Load Balancer?"
echo ""
echo "Type the IP's of the Cloud Servers in the following format:"
echo "example:  10.1.1.1:80,10.1.1.2:80,10.1.1.3:80"
echo ""
echo "Be sure to include the port, commas, and no spaces"
echo ""
echo -n "Type your selection:  "
read cloudservers
echo ""
clb --region $vm_region disable-nodes $lb_id $cloudservers
sleep 5
clb --region $vm_region show $lb_id
echo ""
echo "Press return key to continue..."
read -p "$*"

}


# Main

case "$1" in
--help) help;;
--list-servers) list_servers;;
--lb-list) lb_list;;
--lb-details) lb_details;;
--create-lb) create_lb;;
--lb-stats) lb_stats;;
--lb-current-usage) lb_current_usage;;
--lb-all-usage) lb_all_usage;;
--lb-delete) lb_delete;;
--lb-rename) lb_rename;;
--lb-change-port-protocol) lb_change_port_protocol;;
--lb-change-algorithm) lb_change_algorithm;;
--lb-add-nodes) lb_add_nodes;;
--lb-remove-nodes) lb_remove_nodes;;
--lb-disable-nodes) lb_disable_nodes;;
--lb-show-monitor) lb_show_monitor;;
--lb-show-errorpage) lb_show_errorpage;;
--lb-enable-logging) lb_enable_logging;;
--lb-disable-logging) lb_disable_logging;;
--lb-enable-persistence) lb_enable_persistence;;
--lb-disable-persistence) lb_disable_persistence;;
--lb-enable-tcp-connect-monitor) lb_enable_tcp_connect_monitor;;
--lb-enable-http-monitor) lb_enable_http_monitor;;
--lb-enable-https-monitor) lb_enable_https_monitor;;
--lb-delete-health-monitor) lb_delete_health_monitor;;
--lb-add-acl) lb_add_acl;;
--lb-remove-acl) lb_remove_acl;;
--lb-clear-acl) lb_clear_acl;;
*) exit ;;
esac
