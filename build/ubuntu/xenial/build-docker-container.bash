#!/bin/bash
# This script creates a cozy docker container interior
# Required env variables:
# - ARCH: Build architecture
# - DOCKER_UID: UID of your desktop user
# - DOCKER_GID: GID of your desktop user

apt-get update
apt-get install dpkg-dev

if [[ $ARCH == "x86_64" ]]; then
  # FPM
  apt-get install -y ruby ruby-dev build-essential libgmp-dev
  gem install fpm
  
  # Python
  apt-get install -y python3 python3-pip python3-pkg-resources
fi

if [[ $ARCH == "i386" ]]; then
  echo "i386 not yet implemented!" >&2; exit 254
fi

# Add build user
groupadd -g ${DOCKER_GID} user
useradd --home /build -u ${DOCKER_UID} -g ${DOCKER_GID} -M user
mkdir -p /build/connect /build/bin/${DIST}
chown -R ${DOCKER_UID}:${DOCKER_GID} /build/
