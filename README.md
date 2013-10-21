## rscloudadmin

Menu driven front end wrapper script for the various Rackspace Cloud Tools


### Purpose

To provide a single menu driven interface for managing your infrastructure
within the Rackspace Cloud.  This script serves as nothing more then a
wrapper for existing API wrappers for the Rackspace Cloud such as nova,
openstack-compute, and clb.

IMPORTANT:  Make sure you test all aspects of this script and modules
BEFORE using it on your production solution!  There is very little sanity
checking in place, and no confirmation screens before proceeding.  You have
been warned!!

This script simply makes my life a bit easier as I can never remember all
the options in the nova, openstack-compute, and clb tools.  


### Features

Works with the following Rackspace Cloud products:

- FirstGen Cloud Servers
- NextGen Cloud Servers
- Cloud Block Storage
- Cloud Load Balancers
- Cloud Networks


### Installation

As mentioned earlier, this is wrapper script for the various existing tools
out there for managing infrastructure on the Rackspace Cloud.  These
instructions where written for CentOS 6.4, but they can be easily adapted
for Debian, Gentoo, and others.  

	# Install basics
	rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
	yum install git unzip python-pip gcc python-setuptools

	# Setup nova
	cd /root
	pip install rackspace-novaclient
	git clone git://github.com/openstack/python-novaclient.git
	cd python-novaclient/
	python setup.py install
	cd /root

	# Setup openstack-compute
	# NOTE:  This comes from my fork of it that contains a minor fix
	cd /root
	git clone https://github.com/stephenlang/openstack-compute.git
	cd openstack.compute
	python setup.py install

	# Setup python-cloudlb and clb
	# NOTE:  Python-cloudlb comes from my fork of an older version, which has a
	# minor fix
	cd /root
	git clone https://github.com/stephenlang/python-cloudlb.git
	cd python-cloudlb
	python setup.py install
	cd /root
	git clone https://github.com/calebgroom/clb.git
	cd clb
	python setup.py install

	# Setup rscloudadmin
	cd /root
	git clone https://github.com/stephenlang/rscloudadmin.git


### Usage

Running the script requires nothing more then setting it to executable,
then typing:
	
	./rscloudadmin.sh 

Below is the main menu:

	Rackspace Cloud Admin Management Console  
	Account:  exampleaccount (12345678)


	1)  FirstGen Cloud Servers
	2)  NextGen Cloud Servers
	3)  Cloud Block Storage
	4)  Cloud Networks
	5)  Cloud Load Balancers

	6)  Show Solution Overview 
  
	9)  Quit and Disconnect

	Please select an option:  


Here is are the options for Cloud Block Storage

	Rackspace Cloud Admin Management Console  
	Account:  exampleaccount (12345678)


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

	Please select an option:  

And here are the options for NextGen Cloud Servers:

	Rackspace Cloud Admin Management Console  
	Account:  exampleaccount (12345678)


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

	Please select an option:  


