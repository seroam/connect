#!/bin/bash
# This scripts builds the connect package
# Required env variables:
# - ARCH: Build architecture
# - GPG_KEY: Signing key for GPG

# Prolog
pushd /build/dist >/dev/null

# Import GPG signing key
gpg2 --import <<__EOF__
${GPG_KEY}
__EOF__

# Check if this is a repository; if not, warn and ask to create one.

###############################################################################
# Create repository index
###############################################################################
dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz
#TODO: This should be rewritten to create a real repository with signing.

# Fine.
popd >/dev/null
