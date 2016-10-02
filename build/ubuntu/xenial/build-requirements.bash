#!/bin/bash
# This scripts builds the connect package
# Required env variables:
# - ARCH: Build architecture
# - FPM_DEFAULTS: Default FPM call
FPM_DEB="-t deb --python-easyinstall easy_install3"
###############################################################################
# pyyaml
###############################################################################
${FPM_DEFAULTS} ${FPM_DEB} pyyaml

###############################################################################
# pysmb
###############################################################################
if [[ $ARCH == "x86_64" ]]; then
  ${FPM_DEFAULTS} ${FPM_DEB} pysmb
fi

if [[ $ARCH == "i386" ]]; then
  # TODO: Does this really COMPILE things different?
  ${FPM_DEFAULTS} ${FPM_DEB} --architecture $ARCH pysmb
fi
