#!/bin/bash

#################################################################
#
# demo-install.sh script
#       vr 0.7
#
# Written by Corey Reichle
# 01/28/2015
# Copyright (c) 2015 by Corey Reichle.  Released under GPL 3 or later.
#
#################################################################

cat << _EOF
This script preps a Rasperry Pi to host some demo applications for a mesh node.  This should work on most any Debian
machine, but we're focused on a Pi only because it's very portable.

This script must be executed using sudo or as root.  Networking must already be configured, either via wifi or eth0.
Eth0 may be more "wow" factor, but it really doesn't matter.  Apache will listen on all ports.

_EOF

read -p "Press [Enter] key to start install, or CTRL-C to exit..."
echo "Setting up environment:"
cd /home/pi

# And, for security, and science...  You monster.
echo "Removing un-needed programs..."
apt-get -y purge alsa-base alsa-utils aptitude aspell-en blt console-setup console-setup-linux consolekit cups-bsd dbus dbus-x11 \
debian-reference-common debian-reference-en desktop-base desktop-file-utils dictionaries-common dillo dpkg-dev fakeroot fontconfig \
fontconfig-config fonts-droid fuse galculator gconf2 gconf2-common gdb gksu gnome-accessibility-themes gsfonts gsfonts-x11 idle idle-python2.7 \
lesstif2:armhf libarchive12:armhf libasound2:armhf libaspell15 libasyncns0:armhf libatasmart4:armhf libatk1.0-0:armhf libaudit0 libavahi-client3:armhf \
libavahi-common3:armhf libavahi-glib1:armhf libbluetooth3:armhf libbluray1:armhf libboost-iostreams1.46.1 libboost-iostreams1.48.0 \
libboost-iostreams1.49.0 libboost-iostreams1.50.0 libcaca0:armhf libcairo-gobject2:armhf libcairo2:armhf libcdio-cdda1 libcdio-paranoia1 \
libcdio13 libck-connector0:armhf libcolord1:armhf libcroco3:armhf libcups2:armhf libcupsimage2:armhf libcwidget3 libdaemon0 libdatrie1:armhf \
libdbus-glib-1-2:armhf libdconf0:armhf libdevmapper-event1.02.1:armhf libdirectfb-1.2-9:armhf libdrm2:armhf libept1.4.12 libexif12:armhf \
libffi5:armhf libflac8:armhf libfltk1.3:armhf libfm-data libfm-gtk-bin libfm-gtk1 libfm1 libfontconfig1:armhf libfontenc1:armhf libfreetype6:armhf \
libfuse2:armhf libgail-3-0:armhf libgail18:armhf libgconf-2-4:armhf libgd2-xpm:armhf libgdk-pixbuf2.0-0:armhf libgdu0 libgeoclue0 libgfortran3:armhf \
libgif4 libgksu2-0 libgl1-mesa-glx:armhf libglade2-0 libglapi-mesa:armhf libglib2.0-0:armhf libgnome-keyring0:armhf libgphoto2-2:armhf \
libgphoto2-port0:armhf libgs9 libgstreamer-plugins-base0.10-0:armhf libgstreamer0.10-0:armhf libgtk-3-0:armhf libgtk-3-bin libgtk-3-common \
libgtk2.0-0:armhf libgtk2.0-common libgtop2-7 libgudev-1.0-0:armhf libhunspell-1.3-0:armhf libice6:armhf libicu48:armhf libid3tag0 libident \
libijs-0.35 libimlib2 libimobiledevice2 libjasper1:armhf libjavascriptcoregtk-1.0-0 libjavascriptcoregtk-3.0-0 libjbig0:armhf libjbig2dec0 \
libjson0:armhf liblapack3 liblcms1:armhf liblcms2-2:armhf liblightdm-gobject-1-0 libltdl7:armhf liblvm2app2.2:armhf libmad0 libmagic1:armhf \
libmenu-cache1 libmikmod2:armhf libmng1:armhf libmtdev1:armhf libnettle4:armhf libnih-dbus1 libnih1 libnotify4:armhf libobrender27 libobt0 \
libogg0:armhf libopenjpeg2:armhf liborc-0.4-0:armhf libpango1.0-0:armhf libpaper1:armhf libpci3:armhf libpciaccess0:armhf libpixman-1-0:armhf \
libplist1 libpng12-0:armhf libpolkit-agent-1-0:armhf libpolkit-backend-1-0:armhf libpolkit-gobject-1-0:armhf libpoppler19:armhf libportmidi0 \
libproxy0:armhf libpulse0:armhf libpython2.7 libqt4-network:armhf libqt4-svg:armhf libqt4-xml:armhf libqtcore4:armhf libqtdbus4:armhf \
libqtgui4:armhf libqtwebkit4:armhf libraspberrypi0 librsvg2-2:armhf libsamplerate0:armhf libsdl-image1.2:armhf libsdl-mixer1.2:armhf \
libsdl-ttf2.0-0:armhf libsdl1.2debian:armhf libsgutils2-2 libsm6:armhf libsmbclient:armhf libsmpeg0:armhf libsndfile1:armhf libsoup-gnome2.4-1:armhf \
libsoup2.4-1:armhf libsqlite3-0:armhf libstartup-notification0 libsystemd-login0:armhf libthai0:armhf libtiff4:armhf libts-0.0-0:armhf libunique-1.0-0 \
libusbmuxd1 libvorbis0a:armhf libvorbisenc2:armhf libvorbisfile3:armhf libvte9 libwayland0:armhf libwebkitgtk-1.0-0 libwebkitgtk-3.0-0 libwebp2:armhf \
libwnck22 libx11-6:armhf libx11-xcb1:armhf libxapian22 libxau6:armhf libxaw7:armhf libxcb-glx0:armhf libxcb-render0:armhf libxcb-shape0:armhf \
libxcb-shm0:armhf libxcb-util0:armhf libxcb-xfixes0:armhf libxcb1:armhf libxcomposite1:armhf libxcursor1:armhf libxdamage1:armhf libxdmcp6:armhf \
libxext6:armhf libxfixes3:armhf libxfont1 libxft2:armhf libxi6:armhf libxinerama1:armhf libxkbcommon0:armhf libxkbfile1:armhf libxklavier16 \
libxml2:armhf libxmu6:armhf libxmuu1:armhf libxp6:armhf libxpm4:armhf libxrandr2:armhf libxrender1:armhf libxres1:armhf libxslt1.1:armhf \
libxss1:armhf libxt6:armhf libxtst6:armhf libxv1:armhf libxxf86dga1:armhf libxxf86vm1:armhf lightdm lightdm-gtk-greeter lxappearance lxde-common \
lxde-icon-theme lxmenu-data lxpolkit lxrandr lxtask lxterminal menu menu-xdg midori mime-support mountall netsurf-gtk obconf omxplayer openbox \
pciutils pcmanfm plymouth policykit-1 poppler-data python python-support python2.7 python2.7-minimal python3 python3.2 python3.2-minimal scratch \
sgml-base shared-mime-info squeak-vm tasksel tcl8.5 tk8.5 tsconf udisks update-inetd weston wpagui x11-common x11-utils x11-xserver-utils xarchiver \
xfonts-utils xinit xml-core xpdf xserver-xorg xserver-xorg-core idle-python3.2 idle3 ifplugd info leafpad

apt-get -y autoremove

apt-get cleanall

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