#!/bin/bash

echo 'umount.vishnu.sh is started. Syncing'

sync

echo 'Syncing Finished. unmounting /mnt/wishnu'

sudo umount /mnt/wishnu

echo 'umount.vishnu.sh is finished.'

