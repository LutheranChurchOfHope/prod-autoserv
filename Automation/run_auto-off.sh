#!/bin/bash

# location:
# /opt/scripts/projector-automation/run_auto-off.sh

/opt/scripts/projector-automation/auto-off.sh

echo -e "\n\n" >> /opt/log/projector-automation.log
date +%F_%H%M%S >> /opt/log/projector-automation.log
echo "Ran auto-off script." >> /opt/log/projector-automation.log

#EOF