#!/bin/bash

# location:
# /var/www/cgi-bin/disable_auto-off.sh
echo 'Content-type: text/html'
echo -e "\n\n"

cp /var/www/html/javascript/auto-off_disabled.txt /var/www/html/javascript/auto-off.js

echo -e "\n\n" >> /opt/log/projector-automation.log
date +%F_%H%M%S >> /opt/log/projector-automation.log
echo "Disabled auto-off." >> /opt/log/projector-automation.log
#EOF