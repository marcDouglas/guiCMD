#!/bin/bash

echo 'guiCMD/screens/syncDrive/bin/syncDrive.flowers.sh is started. '
echo "."

sudo rsync -aAXv --delete --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found","/srv/*","/var/cache/pacman/pkg","home/shawna/.cache/*","/home/shawna/Desktop/movies/*","/tmp/*"} / /run/media/shawna/BumbleBee/backups/flower.11.2.17/
echo "."
sleep 1
echo "syncDrive.sh is finished."
sleep 5
