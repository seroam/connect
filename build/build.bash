#!/bin/bash
set -e
usage(){
  echo "Usage:"
  echo "./build.bash DISTRIBUTION DIST_VERSION (x86_64|i386) (all|docker|connect|requirements|repository)"
  exit 255
}

###############################################################################
# CLI
###############################################################################
# Distribution
if [ -n "${1}" ] && [ -d "./${1}" ]; then
	export DIST="$1"
else
	echo "Invalid distribution!" >&2; usage;
fi

# Version
if [ -n "${2}" ] && [ -d "./${1}/${2}" ]; then
	export DIST_VERSION="$2"
else
	echo "Invalid distribution version!" >&2; usage;
fi;

# Architecture
case "$3" in
  "i386" | "x86_64") export ARCH="$3"
  ;;
  *) echo "Invalid architecture!" >&2; usage;
  ;;
esac

# Mode
case "$4" in
  "all" | "docker" | "connect" | "requirements" | "repository" ) export MODE="$4"
  ;;
  *) echo "Invalid mode!" >&2; usage;
  ;;
esac

###############################################################################
# ENV
###############################################################################
# relative root need to be resolved:
export BUILDROOT=`readlink -f "${BUILDROOT:="../"}"`
export BUILDDEST=`readlink -f "${BUILDDEST:="../bin"}"`

# Building user IDs (it might be usfull to change this to your local user)
export DOCKER_UID=${DOCKER_UID:=1000}
export DOCKER_GID=${DOCKER_GID:=1000}

# Distribution and packaging format
export DIST="ubuntu" #TODO: This comes from outside in the future.
export DOCKER_RUN="${DOCKER_RUN:="docker run --interactive --tty --rm"}"
export FPM_DEFAULTS="fpm -s python --package /build/bin/ \
      --python-bin python3 --python-package-name-prefix python3"

export FPM_DEFAULTS_CONNECT="${FPM_DEFAULTS_CONNECT:="-n openhsr-connect --license GPL \
	-d python3 -d cups \
        -x Makefile -x build -x '.git*'"}"
	#TODO^: Create symlink to cups with
	# --after-install setup.sh --before-remove uninstall.sh

# Prolog
pushd "./${DIST}/${DIST_VERSION}/" >/dev/null

###############################################################################
# docker: Build docker container
###############################################################################
if [ $MODE == "docker" ] || [ $MODE == "all" ]; then

  # Detect dockerfile for ARCH
  if [ -f "dockerfile-${ARCH}" ]; then
    DOCKERFILE="dockerfile-${ARCH}"
  elif [ -f "dockerfile" ]; then
    DOCKERFILE="dockerfile"
  fi

  # Build container
  docker build \
    -t "openhsr/openhsr-connect-${DIST}-${DIST_VERSION}-${ARCH}" \
    --build-arg ARCH --build-arg DOCKER_UID --build-arg DOCKER_GID \
    -f ${DOCKERFILE} .
fi

###############################################################################
# connect: Build open\HSR connect
###############################################################################
if [ $MODE == "connect" ] || [ $MODE == "all" ]; then
  CONNECT_BUILDDEST=${BUILDDEST}/${DIST}/${DIST_VERSION}/connect
  mkdir -p $CONNECT_BUILDDEST &&
    chown -R ${DOCKER_UID}:${DOCKER_GID} $BUILDDEST
  rm ${CONNECT_BUILDDEST}/* #TODO: This is possibly dangerous.

  ${DOCKER_RUN} --name "openhsr-connect-${DIST}-${DIST_VERSION}-${ARCH}-connect" \
    --volume=${BUILDROOT}:/build/connect \
    --volume=${CONNECT_BUILDDEST}:/build/bin \
    --env ARCH \
    --env DOCKER_UID --env DOCKER_GID \
    --env FPM_DEFAULTS --env FPM_DEFAULTS_CONNECT \
    openhsr/openhsr-connect-${DIST}-${DIST_VERSION}-${ARCH} \
    /build/connect/build/${DIST}/${DIST_VERSION}/build-connect.bash 

fi

###############################################################################
# requirements: missing dependencies for this plattform.
###############################################################################
if [ $MODE == "requirements" ] || [ $MODE == "all" ]; then
  REQ_BUILDDEST=${BUILDDEST}/${DIST}/${DIST_VERSION}/requirements
  mkdir -p $REQ_BUILDDEST &&
    chown -R ${DOCKER_UID}:${DOCKER_GID} $BUILDDEST
  rm -f ${REQ_BUILDDEST}/* #TODO: This could possibly be dangerous.

  ${DOCKER_RUN} --name "openhsr-connect-${DIST}-${DIST_VERSION}-${ARCH}-connect" \
    --volume=${BUILDROOT}:/build/connect \
    --volume=${REQ_BUILDDEST}:/build/bin \
    --env ARCH \
    --env DOCKER_UID --env DOCKER_GID \
    --env FPM_DEFAULTS \
    openhsr/openhsr-connect-${DIST}-${DIST_VERSION}-${ARCH} \
    /build/connect/build/${DIST}/${DIST_VERSION}/build-requirements.bash 

fi

###############################################################################
# repository: file repositories for shareing
###############################################################################
if [ $MODE == "repository" ] || [ $MODE == "all" ]; then
  REP_BUILDDEST=${BUILDDEST}/${DIST}/${DIST_VERSION}/repository/ # TODO: Add arch to path
  mkdir -p $REP_BUILDDEST &&
    chown -R ${DOCKER_UID}:${DOCKER_GID} $BUILDDEST
  rm -f ${REP_BUILDDEST}/* #TODO: This could possibly be dangerous.

  # Copy all packages to repository
  cp -a ${BUILDDEST}/${DIST}/${DIST_VERSION}/*/* ${REP_BUILDDEST} || (echo "Repository: No packages could be found." >&2 && exit 30) #TODO: This could possibly be dangerous

  ${DOCKER_RUN} --name "openhsr-connect-${DIST}-${DIST_VERSION}-${ARCH}-connect" \
    --volume=${BUILDROOT}:/build/connect \
    --volume=${REP_BUILDDEST}:/build/bin \
    --env ARCH \
    --env DOCKER_UID --env DOCKER_GID \
    openhsr/openhsr-connect-${DIST}-${DIST_VERSION}-${ARCH} \
    /build/connect/build/${DIST}/${DIST_VERSION}/build-repository.bash 

fi

# Fine.
popd >/dev/null
