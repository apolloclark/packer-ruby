#!/bin/bash -eux
start=`date +%s`

# ensure that ENV VARs are set
export DOCKER_USERNAME=${DOCKER_USERNAME:=$(whoami)}
export PACKAGE=${PACKAGE:=ruby}
export PACKAGE_VERSION=${PACKAGE_VERSION:=2.6.3}
export BASE_IMAGE=${BASE_IMAGE:="centos:7.6.1810"}
export IMAGE_NAME=${IMAGE_NAME:="centos7.6"}

# remove previously built local images
docker image rmi $DOCKER_USERNAME/$PACKAGE:$PACKAGE_VERSION-$IMAGE_NAME-$(date -u '+%Y%m%d') -f  || true
docker image rmi $DOCKER_USERNAME/$PACKAGE:$PACKAGE_VERSION-$IMAGE_NAME -f  || true
docker container rm $PACKAGE_VERSION-$IMAGE_NAME -f || true



# run Packer
packer validate packer_docker.json
packer inspect packer_docker.json
packer build packer_docker.json

end=`date +%s`
secs=$((end-start))
printf 'runtime = %02dh:%02dm:%02ds\n' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))



# test the Docker image w/ Serverspec
rspec ./spec/Dockerfile_$IMAGE_NAME.rb

# push images
docker push $DOCKER_USERNAME/$PACKAGE:$PACKAGE_VERSION-$IMAGE_NAME-$(date -u '+%Y%m%d');
docker push $DOCKER_USERNAME/$PACKAGE:$PACKAGE_VERSION-$IMAGE_NAME;

end=`date +%s`
secs=$((end-start))
printf 'runtime = %02dh:%02dm:%02ds\n' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))
