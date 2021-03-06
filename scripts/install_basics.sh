#!/bin/bash -eux

if [ -x "$(command -v apt-get)" ]; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get update
    apt-get upgrade -yq
    apt-get install -yq aptitude software-properties-common python-minimal \
      nano curl wget git gnupg2 apt-transport-https procps
elif [ -x "$(command -v dnf)" ]; then
    dnf makecache
    dnf --assumeyes install which nano curl wget git gnupg2 initscripts \
        hostname python3 patch autoconf automake bzip2 gcc-c++ libffi-devel \
        libtool make patch ruby sqlite-devel zlib-devel glibc-headers \
        glibc-devel openssl-devel # readline-dev bison
    dnf clean all
elif [ -x "$(command -v yum)" ]; then
    yum makecache fast
    yum update -y
    yum install -y which nano curl wget git gnupg2 initscripts hostname tar
    yum clean all
fi

# https://github.com/inversepath/usbarmory-debian-base_image/issues/9
# https://github.com/nextcloud/docker/pull/687#issuecomment-472481276
# https://github.com/docker-library/official-images/issues/4252#issuecomment-381783035
mkdir ~/.gnupg && echo "disable-ipv6" >> ~/.gnupg/dirmngr.conf

# https://github.com/rvm/rvm/issues/4573
gpg --keyserver hkp://keys.gnupg.net \
    --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
    7D2BAF1CF37B13E2069D6956105BD0E739499BDB || true
