#!/bin/bash

ssh marc@pi314 'cd /home/marc/bin/guicmd/;git pull;cd screens/mpdController;./install.sh'
ssh marc@pi315 'cd /home/marc/bin/guicmd/;git pull;cd screens/mpdController;./install.sh'
ssh marc@vader 'cd /home/marc/bin/guicmd/;git pull;cd screens/mpdController;./install.sh'
