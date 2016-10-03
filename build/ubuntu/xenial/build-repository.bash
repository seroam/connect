#!/bin/bash
# This scripts builds the connect package
# Required env variables:
# - ARCH: Build architecture

# Prolog
pushd /build/dist >/dev/null

###############################################################################
# Create repository index
###############################################################################
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
#TODO: This should be rewritten to create a real repository with signing.

# Fine.
popd >/dev/null
