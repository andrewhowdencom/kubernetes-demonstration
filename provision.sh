#!/bin/bash
# Dirty hax to provision ubuntu 16.04 with all that's required to get up and running for the Kubernetes demonstration
# Should be idempotent

# Fail on the first command failure, and be verbose about the bash commands being run
set -ex

# Upgrade the distro to the most recent version
sudo apt-get update && \
  sudo apt-get dist-upgrade -y

# ------
# Docker
# -------
# - https://docs.docker.com/engine/installation/linux/ubuntulinux/

# Add the required apt packages to install docker
sudo apt-get update > /dev/null && \
  sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    git

# Add the docker page GPG key
sudo apt-key adv \
  --keyserver hkp://p80.pool.sks-keyservers.net:80 \
  --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

# Add the docker repo
echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | \
  sudo tee /etc/apt/sources.list.d/docker.list

# Add the linux headers required for Docker
sudo apt-get update > /dev/null && \
  sudo apt-get install -y \
    linux-image-extra-`uname -r` \
    linux-image-extra-virtual

# Install the docker engine
sudo apt-get install -y \
  docker-engine

# Add the ubuntu user to the docker group, so we can use docker without sudo
sudo usermod -a -G docker ubuntu

# ------------
# Google Cloud
# ------------
# - https://cloud.google.com/sdk/downloads#apt-get

# Create an environment variable for the correct distribution
export CLOUD_SDK_REPO="cloud-sdk-`lsb_release -c -s`"

# Add the Cloud SDK distribution URI as a package source
echo "deb https://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | \
  sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list

# Import the Google Cloud public key
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
  sudo apt-key add -

# Update and install the Cloud SDK
sudo apt-get update > /dev/null && \
  sudo apt-get install -y \
    google-cloud-sdk \
    kubectl

# ------------------------
# Create the demonstration
# ------------------------

mkdir -p ${HOME}/Development
git clone https://github.com/andrewhowdencom/kubernetes-demonstration.git ${HOME}/Development/demo
