#!/bin/bash -eux

# ensure that ENV VARs are set
export DOCKER_USERNAME=${DOCKER_USERNAME:=$(whoami)}
export PACKAGE=${PACKAGE:=ruby}
export PACKAGE_VERSION=${PACKAGE_VERSION:=2.6.3}
export BASE_IMAGE=${BASE_IMAGE:="ubuntu:16.04"}
export IMAGE_NAME=${IMAGE_NAME:="ubuntu16.04"}

./build_packer_docker.sh
