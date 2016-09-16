.PHONY: build test

# FPM configuration
FPM-DEPENDS=-d python3 -d cups
FPM-EXCLUDES=-x Makefile -x build -x ".git*"
FPM-PYTHON=--python-bin python3 --python-package-name-prefix python3
#TODO: Create symlink to cups
#--after-install setup.sh --before-remove uninstall.sh
FPM-PARAMS=-s "python" -n "openhsr-connect" --license GPL $(FPM-PYTHON) $(FPM-PYTHON-DEPENDS) $(FPM-DEPENDS) $(FPM-EXCLUDES) connect/setup.py

# Docker configuration
DOCKER-RUN=docker run -it --rm -v $(shell pwd):/src/connect

# General configuration
## This UID and GID are used to set the build files owner.
UID=1000
GID=1000
dists=ubuntu16.04/deb fedora24/rpm fedora23/rpm
default: build

# Helper targets
clean:
	-[ -d build ] && rm -r  build/

# Targets
build: clean $(dists)

# Build deb based distributions
$(filter %/deb,$(dists)):
	    $(eval FPM-DIST-OPTIONS := -t deb --python-easyinstall easy_install3)
	    mkdir -p build/$(@D) && chown -R $(UID):$(GID) build
	# Build
	docker build -t "openhsr/openhsr-connect-$(@D)" docker/$(@D)
	$(DOCKER-RUN) --name "openhsr-connect-$(@D)" openhsr/openhsr-connect-$(@D) fpm $(FPM-DIST-OPTIONS) --package connect/build/$(@D)/ $(FPM-PARAMS)

# Build rpm based distributions
$(filter %/rpm,$(dists)):
	$(eval FPM-DIST-OPTIONS := -t rpm --python-disable-dependency pyyaml -d python3-PyYAML --python-easyinstall easy_install-3.4)
	    mkdir -p build/$(@D) && chown -R $(UID):$(GID) build
	# Build
	docker build -t "openhsr/openhsr-connect-$(@D)" docker/$(@D)
	$(DOCKER-RUN) --name "openhsr-connect-$(@D)" openhsr/openhsr-connect-$(@D) fpm $(FPM-DIST-OPTIONS) --package connect/build/$(@D)/ $(FPM-PARAMS)
