#!/bin/bash -eux

# ensure that ENV VARs are set
export DOCKER_USERNAME=${DOCKER_USERNAME:=$(whoami)}
export PACKAGE_NAME=${PACKAGE_NAME:=ruby}
export PACKAGE_VERSION=${PACKAGE_VERSION:=2.6.3}

./build_packer_docker_ubuntu16.04.sh
./build_packer_docker_centos7.6.sh
