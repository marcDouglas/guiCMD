#!/bin/bash

echo 'umount.sh is started.'
sync

sudo umount /run/media/marc/BumbleBee

sleep 2

echo 'umount.sh is finished.'

