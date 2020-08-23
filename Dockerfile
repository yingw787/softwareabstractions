# Ubuntu 20.04 LTS
FROM ubuntu:focal-20200729
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

# Use Java 6u45 for 64-bit Linux as jar 'jdk-6u45-linux-x64.bin' copied from
# 'https://www.oracle.com/java/technologies/javase-java-archive-javase6-downloads.html'
# into '${GIT_REPO_ROOT}'.
#
# NOTE: From the website, Alloy 4.x is meant to work with Java 6.x.
ARG JAVA6_DIRNAME=jdk1.6.0_45
ENV JAVA_HOME=/opt/${JAVA6_DIRNAME}/bin
ENV PATH=${JAVA_HOME}:${PATH}

# Install X11-specific materials for the Alloy GUI.
# From: https://stackoverflow.com/a/25168483/1497211
RUN apt-get install -y x11-apps
RUN apt-get install -y x11-xserver-utils
RUN apt-get install -y xauth

# TODO: I think there are some dependencies that Alloy requires that Firefox
# also uses and without which the Alloy GUI breaks. Break out the dependencies
# so that Firefox doesn't need to be installed.
RUN apt-get install -y firefox

# Run commands.
CMD [ "exec", "\"@\"" ]
