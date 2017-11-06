#!/bin/bash

echo 'guiCMD/screens/syncDrive/bin/syncDrive.vishnu.sh is started. '
echo 'vishnu is now backing up to wishnu. We will need your password' 
sleep 1
echo""
echo""
sudo rsync -aAXv --delete --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/srv/*","home/marc/build/*","/var/cache/pacman/pkg","/home/marc/.android/*","/home/marc/.cache/*","home/marc/.local/share/Steam/*","home/marc/documents/marcDouglas.us/public_html/android-apps/*","/home/marc/downloads/*","/opt/android-ndk/*","/opt/android-studio/*","/home/marc/.kodi/userdata/*","/home/marc/.mozilla/*","/tmp/*"} / /mnt/wishnu/backups/vishnu_7.7.17/
echo "."
sleep 1
echo "syncDrive.sh is finished."
sleep 5
