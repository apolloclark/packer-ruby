#!/bin/bash -eux

if [ -x "$(command -v apt-get)" ]; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get upgrade -yq
    apt-get install -yq aptitude python-minimal nano curl wget git apt-transport-https gnupg2
fi

if [ -x "$(command -v yum)" ]; then
    yum update -y
    yum install -y sudo which nano curl wget git gnupg2
fi
