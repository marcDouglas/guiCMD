#!/bin/bash

echo 'umount.flower.sh is started. Syncing...'

sync

echo 'Syncing Discs is Finished.  umounting...'

sudo umount /run/media/marc/BumbleBee

echo 'umount.flower.sh is finished.'

