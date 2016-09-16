FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y ruby ruby-dev build-essential libgmp-dev
RUN gem install fpm

RUN mkdir -p /src/connect
WORKDIR /src

# Install build requirements
RUN apt-get install -y python3 python3-pip python3-pkg-resources

# Create new user - to prevent user id issues
RUN groupadd -g 1000 user
RUN useradd --home /src -u 1000 -g 1000 -M user
USER user
