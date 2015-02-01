#!/bin/bash

#################################################################
#
# debian-demo.sh script
#       vr 0.5
#
# Written by Corey Reichle
# 01/31/2015
# Copyright (c) 2015 by Corey Reichle.  Released under GPL 3 or later.
#
#################################################################

cat << _EOF
This script preps a Debian-based machine to host some demo applications for a mesh node. It should work on any
Debian based distro, but tested against the current Debian and Ubuntu distros.

This script must be executed using sudo or as root.  Networking must already be configured, either via wifi or eth0.
Eth0 may be more "wow" factor, but it really doesn't matter.  Apache will listen on all ports.

If you already have an Apache instance set up, DO NOT RUN THIS.  It will likely clobber your web content.  You can
do the bulk of the work by cloning in the appropriate repos:

cd /var/www
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
apt-get update
apt-get -y install apache2 mysql-server php5 php5-mysql git-core

cd /var/www

echo "Cloning in the applications..."
echo "Wiki copy..."
git clone https://github.com/BuffaloMeshDotNet/website.git
echo "Chat..."
git clone https://github.com/BuffaloMeshDotNet/webchat.git
touch /var/www/webchat/msg.html
chmod ugo+rw /var/www/webchat/msg.html
echo "Library..."
git clone https://github.com/BuffaloMeshDotNet/library.git

cat > /var/www/index.html << _EOF
<html>
<head>
<title>BuffaloMesh Demo Node</title>
</head>
<body>
<h1><a href="website">Read-Only Wiki</a></h1>
<h1><a href="webchat">Web Chat</a></h1>
<h1><a href="library">Library</a></h1>
</body>
</html>
_EOF

echo "All set up!  Point the browser to one of the following addresses:"
ifconfig `route | sed -n '3,$p' | grep "default" | awk '{print $8}'` | grep inet | awk '{ print $2 }' | awk -F":" '{print $2}'
