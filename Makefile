# This makefile helps you building distribution packages of openhsr-connect
# Usage:
#   make			Build packages for all distributions, formats 
#   				  and dependencies
#   make ubuntu16.04/deb	Build packages for ubuntu 16.04 (deb)
#   make ubuntu16.04/deb/pysmb	Build a pysmb package for ubuntu 16.04 (deb)
#
###############################################################################
# Configuration
###############################################################################
# FPM configuration
FPM-DEPENDS=-d python3 -d cups
FPM-EXCLUDES=-x Makefile -x build -x ".git*"
FPM-PYTHON=--python-bin python3 --python-package-name-prefix python3
#TODO: Create symlink to cups
#--after-install setup.sh --before-remove uninstall.sh
FPM-PARAMS=-s "python" -n "openhsr-connect" --license GPL \
	$(FPM-PYTHON) $(FPM-DEPENDS) $(FPM-EXCLUDES) connect/setup.py

# Docker configuration
DOCKER-RUN=docker run -it --rm -v $(shell pwd):/src/connect

# General configuration
## This UID and GID are used to set the build files owner.
UID=1000
GID=1000
dists=ubuntu16.04/deb fedora24/rpm fedora23/rpm
default: build
.PHONY: clean build $(dists) pyyaml pysmb

# Helper targets
clean:
	-[ -d build ] && rm -r  build/

# Targets
build: clean $(dists)

###############################################################################
# Build openhsr-connect
###############################################################################
# $(@D) is the first ("directory") part of the target e.g. ubuntu16.04

# Build deb based distributions
$(filter %/deb,$(dists))::
	mkdir -p build/$(@D) && chown -R $(UID):$(GID) build
	# Build
	docker build -t "openhsr/openhsr-connect-$(@D)" docker/$(@D)
	$(DOCKER-RUN) --name "openhsr-connect-$(@D)" openhsr/openhsr-connect-$(@D) \
		fpm -t deb --python-easyinstall easy_install3 \
		  --package connect/build/$(@D)/ $(FPM-PARAMS)

# Build rpm based distributions
$(filter %/rpm,$(dists))::
	mkdir -p build/$(@D) && chown -R $(UID):$(GID) build
	# Build
	docker build -t "openhsr/openhsr-connect-$(@D)" docker/$(@D)
	#TODO: It's only easy_install-3.4 on Fedora 23, 3.5 on Fedora 24...
	$(DOCKER-RUN) --name "openhsr-connect-$(@D)" openhsr/openhsr-connect-$(@D) \
		fpm -t rpm --python-easyinstall easy_install-3.4 \
		  --python-disable-dependency pyyaml -d python3-PyYAML \
		  --package connect/build/$(@D)/ $(FPM-PARAMS)


###############################################################################
# Build python libraries
###############################################################################
# TODO: Are there version requirements that should be enforced?

# Missing Python library dependencies per distribution:
ubuntu14.04/deb:: $@/pyyaml $@/pysmb
ubuntu16.04/deb:: $@/pyyaml $@/pysmb
fedora23/rpm:: $@/pysmb
fedora24/rpm:: $@/pysmb

# pyyaml
#TODO: pyyaml does c compilation; that means, we need to add another dimension: arch.
$(foreach dist,$(dists),$(dist)/pyyaml): 
	$(eval TP=$(subst /, ,$@))
	$(eval CONTAINER=$(word 1,$(TP)))
	# TODO: easyinstall should be set through switch case or alike.(currently ubuntu only)
	docker build -t "openhsr/openhsr-connect-$(CONTAINER)" docker/$(CONTAINER)
	$(DOCKER-RUN) --name "openhsr-connect-$(CONTAINER)" openhsr/openhsr-connect-$(CONTAINER) \
		fpm -s "python" -t "$(word 2,$(TP))" $(FPM-PYTHON) --python-easyinstall easy_install3 \
		  --package connect/build/$(CONTAINER)/ $(word 3,$(TP))

#TODO: pysmb

###############################################################################
# Create repositories
###############################################################################

#TODO:
# - For each distribution-version-arch we need to build a repository
# - The packages must probably be signed
