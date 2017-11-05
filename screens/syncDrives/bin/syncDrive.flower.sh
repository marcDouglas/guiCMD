#!/bin/bash

echo 'guiCMD/screens/syncDrive/bin/syncDrive.sh is started. '
echo 'sudo rsync -aAXv --delete --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/srv/*","/var/cache/pacman/pkg"} / /mnt/wishnu/'
echo "."
echo "clone this file. then setup your own, this does nothing, must uncomment line below."
echo "format is rsync -aAXv --delete --exclude={<see below, but excludes things that you really should, i add cache files and such as well>} <root folder> <destination folder>"

#sudo rsync -aAXv --delete --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/srv/*","/var/cache/pacman/pkg"} / /mnt/wishnu/


sleep 1
echo ".."
echo "."
echo "syncDrive.sh is finished."
