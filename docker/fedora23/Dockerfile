FROM fedora:23

# RUN apt-get update
RUN dnf install -y ruby glibc-devel gcc gcc-c++ make gmp-devel
RUN dnf install -y ruby-devel rpm-build rpmdevtools redhat-rpm-config
RUN gem install fpm

RUN dnf install -y python3-devel libffi-devel openssl-devel dbus-python

RUN mkdir -p /src/connect
WORKDIR /src

# Create new user - to prevent user id issues
RUN groupadd -g 1000 user
RUN useradd --home /src -u 1000 -g 1000 -M user
USER user
