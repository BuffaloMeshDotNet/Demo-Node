#!/bin/bash

#################################################################
#
# centos-demo.sh script
#       vr 0.1
#
# Written by Corey Reichle
# 01/31/2015
# Copyright (c) 2015 by Corey Reichle.  Released under GPL 3 or later.
#
#	This is SOOOOOOO not tested on anything.  Maybe in a week
#	or so I'll get to it.
#
#################################################################

cat << _EOF
This script preps a CentOS-based machine to host some demo applications for a
mesh node. It should work on any CentOS based distro, but tested against CentOS
6 and 7.

This script must be executed using sudo or as root.  Networking must already be
configured, either via wifi or eth0.  Eth0 may be more "wow" factor, but it
really doesn't matter.  Apache will listen on all ports.

If you already have an Apache instance set up, DO NOT RUN THIS.  It will likely
clobber your web content.  You can do the bulk of the work by cloning in the
appropriate repos:

cd /var/www/html
git clone https://github.com/BuffaloMeshDotNet/website.git
git clone https://github.com/BuffaloMeshDotNet/webchat.git
touch /var/www/webchat/msg.html
chmod ugo+rw /var/www/webchat/msg.html
git clone https://github.com/BuffaloMeshDotNet/library.git

_EOF

read -p "Press [Enter] key to start install, or CTRL-C to exit..."

echo "Getting files:"

# We need the LAMP stack, plus git-core so we can clone down all of the apps
echo "Installing required programs via apt..."
yum update
yum install -y httpd php php-mysql php-pdo php-gd php-mbstring mariadb-server mariadb

chkconfig mariadb on
chkconfig httpd on

cd /var/www/html

echo "Cloning in the applications..."
echo "Wiki copy..."
git clone https://github.com/BuffaloMeshDotNet/website.git
sed -i.bak -e '7d;8d' /var/www/html/website/local/config.php
echo "Chat..."
git clone https://github.com/BuffaloMeshDotNet/webchat.git
touch /var/www/webchat/msg.html
chmod ugo+rw /var/www/webchat/msg.html
echo "Library..."
git clone https://github.com/BuffaloMeshDotNet/library.git

echo "Writing out a sample index file..."
cat > /var/www/index.html << _EOF
<html>
	<head>
		<link rel="stylesheet" href="style.css"/>
		<title>BuffaloMesh Demo Node</title>
	</head>
	<body>
		<div class="menu"><h1><a href="website/pmwiki.php" target="#content">Read-Only Wiki</a></h1></div>
		<div class="menu"><h1><a href="webchat" target="#content">Web Chat</a></h1></div>
		<div class="menu"><h1><a href="library" target="#content">Library</a></h1></div>
		<iframe name="#content" class="framebox" src="website/pmwiki.php"></iframe>
	</body>
</html>
_EOF

cat > /var/www/style.css << _EOF
.body
{
	width:99%;
}

.framebox
{
	float:left;
	overflow-y:scroll;
	width: 99%;/*the outermost div is always a % of the page
					width, even while resizing*/
	height:85%;
	display:inline-block;
}

.menu
{
	float:left;
	width:33%;
	height:10%;
	text-align:center;
}
_EOF

echo "All set up!  Point the browser to the following address, or configure the Commotion apps to point here:"
ifconfig `route | sed -n '3,$p' | grep "default" | awk '{print $8}'` | grep inet | awk '{ print $2 }' | awk -F":" '{print $2}'
