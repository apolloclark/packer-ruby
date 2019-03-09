#!/bin/bash -eux

printenv | grep rvm
rvm --version
ruby --version
gem --version
gem install serverspec docker-api infrataster --no-doc
gem list | grep serverspec
