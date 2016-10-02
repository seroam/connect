#!/bin/bash
PACKAGE_PATH="/usr/local/lib/python3.5/dist-packages/openhsr_connect"
BACKEND_SCRIPT="/usr/lib/cups/backend/openhsr-connect"

if [ -f ${BACKEND_SCRIPT} ]; then
	rm ${BACKEND_SCRIPT}
fi

# Remove printer if installed
lpstat -a openhsr-connect 2&> /dev/null
if [ $? -eq 0 ]; then
    echo "Removing printer openhsr-connect"
    lpadmin -x openhsr-connect
fi
