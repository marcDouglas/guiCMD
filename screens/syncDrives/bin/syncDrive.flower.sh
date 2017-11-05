#!/bin/bash

echo 'guiCMD/screens/syncDrive/bin/syncDrive.sh is started. '
echo "."

sudo rsync -aAXv --delete --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/srv/*","/var/cache/pacman/pkg","home/shawna/.cache/*","/home/shawna/Desktop/movies/*"} / /run/media/shawna/BumbleBee/backups/flower.11.2.17/

echo "."
echo "syncDrive.sh is finished."
