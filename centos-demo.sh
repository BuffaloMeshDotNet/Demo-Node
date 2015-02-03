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
This script preps a CentOS-based machine to host some demo applications for a mesh node. It should work on any
CentOS based distro, but tested against CentOS 6 and 7.

This script must be executed using sudo or as root.  Networking must already be configured, either via wifi or eth0.
Eth0 may be more "wow" factor, but it really doesn't matter.  Apache will listen on all ports.

If you already have an Apache instance set up, DO NOT RUN THIS.  It will likely clobber your web content.  You can
do the bulk of the work by cloning in the appropriate repos:

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

cat > /var/www/html/index.html << _EOF
<html>
<head>
<title>BuffaloMesh Demo Node</title>
</head>
<body>
<h1><a href="website/pmwiki.php">Read-Only Wiki</a></h1>
<h1><a href="webchat">Web Chat</a></h1>
<h1><a href="library">Library</a></h1>
</body>
</html>
_EOF

echo "All set up!  Point the browser to the following address, or configure the Commotion apps to point here:"
ifconfig `route | sed -n '3,$p' | grep "default" | awk '{print $8}'` | grep inet | awk '{ print $2 }' | awk -F":" '{print $2}'
