#!/bin/bash

#################################################################
#
# demo-install.sh script
#       vr 0.1
#
# Written by Corey Reichle
# 01/28/2015
# Copyright (c) 2015 by Corey Reichle.  Released under GPL 3 or later.
#
#################################################################

cat << '_EOF'
This script preps a Rasperry Pi to host some demo applications for a mesh node.  This should work on most any Debian
machine, but we're focused on a Pi only because it's very portable.

This script must be executed using sudo or as root.  Networking must already be configured, either via wifi or eth0.
Eth0 may be more "wow" factor, but it really doesn't matter.  Apache will listen on all ports.

'_EOF'

read -p "Press [Enter] key to start install, or CTRL-C to exit..."
echo "Setting up environment:"
cd /home/pi

echo "Getting files:"

# We need the LAMP stack, plus git-core so we can clone down all of the apps
echo "Installing required programs via apt..."
apt-get update
apt-get -y install sudo apt-get install apache2 mysql-server php5 php5-mysql git-core

cd /var/www

echo "Cloning in the applications..."
echo "Wiki copy..."
git clone https://github.com/BuffaloMeshDotNet/website.git
echo "Chat..."
git clone https://github.com/BuffaloMeshDotNet/webchat.git
echo "Library..."
git clone https://github.com/BuffaloMeshDotNet/library.git

cd /var/www/library
cat > /var/www/index.html << '_EOF'
<html>
<head>
<title>BuffaloMesh Demo Node</title>
</head>
<body>
<h1><a href="website">Read-Only Wiki</a></h1>
<h1><a href="webchat">Web Chat</a></h1>
<h1><a href="Library">Library</a></h1>
</body>
</html>
'_EOF'
