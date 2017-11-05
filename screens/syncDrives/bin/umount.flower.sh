#!/bin/bash

echo 'umount.flower.sh is started. Syncing...'

sync

echo 'Syncing Discs is Finished.  umounting...'

sudo umount /run/media/shawna/BumbleBee
sudo umount /run/media/shawna/use_ext4_fs

echo 'umount.flower.sh is finished.'

