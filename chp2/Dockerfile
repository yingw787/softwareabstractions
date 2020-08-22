FROM debian:buster-20200514
LABEL maintainer="Ying Wang"
LABEL application="softwareabstractions"

# Set build arguments.
ARG DEBIAN_FRONTEND=noninteractive
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

# Get package lists, important for getting 'curl' and such.
RUN apt-get -y update

# Install build dependencies.
RUN apt-get install -y curl

# Setup workdirectory.
RUN mkdir /app
WORKDIR /app

# Run commands.
CMD [ "exec", "\"@\"" ]
