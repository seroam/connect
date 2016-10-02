#!/bin/bash
PACKAGE_PATH="/usr/local/lib/python3.5/dist-packages/openhsr_connect"
BACKEND_SCRIPT="/usr/lib/cups/backend/openhsr-connect"

if [ ! -f ${BACKEND_SCRIPT} ]; then
    ln -s "${PACKAGE_PATH}/scripts/openhsr-connect" ${BACKEND_SCRIPT}
    chmod 700 ${BACKEND_SCRIPT}
    chown root:root ${BACKEND_SCRIPT}
fi

# Add the printer if not yet installed
lpstat -a openhsr-connect 2&> /dev/null
if [ $? -ne 0 ]; then
    echo "Adding printer openhsr-connect"
    lpadmin -p openhsr-connect -E -v openhsr-connect:/tmp -P ${PACKAGE_PATH}/scripts/Generic-PostScript_Printer-Postscript.ppd
fi
