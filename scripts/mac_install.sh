#!/bin/sh
#Mac installation

echo "Change Security to foce login and screen saver password"
read x

# Crazy download manager
echo "http://quicksilver.en.softonic.com/mac/download"
read x


curl -o synergy.dmg http://downloads.sourceforge.net/project/synergykm/Binaries/1.0%20Beta%207/SynergyKM-1.0b7-Installer.dmg?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fsynergykm%2F&ts=1322942316&use_mirror=superb-sea2
ohdiutil mount macports.dmg

curl -o macports.dmg https://distfiles.macports.org/MacPorts/MacPorts-2.0.3-10.7-Lion.dmg
ohdiutil mount macports.dmg


echo "Install Synergy & macports"
read x
export PATH=/opt/local/bin/:$PATH

sudo port -v selfupdate
sudo port upgrade outdated
sudo port install ImageMagick
echo "iMac Calendar Sync - http://www.google.com/support/calendar/bin/answer.py?answer=99358#ical"

