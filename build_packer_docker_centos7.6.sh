#!/bin/bash -eux

# ensure that ENV VARs are set
export DOCKER_USERNAME=${DOCKER_USERNAME:=$(whoami)}
export PACKAGE=${PACKAGE:=ruby}
export PACKAGE_VERSION=${PACKAGE_VERSION:=2.6.1}
export BASE_IMAGE=${BASE_IMAGE:="centos:7.6.1810"}
export IMAGE_NAME=${IMAGE_NAME:="centos7.6"}

./build_packer_docker.sh
