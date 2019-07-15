#!/bin/bash -eux
start=`date +%s`

# ensure that ENV VARs are set
export DOCKER_USERNAME=${DOCKER_USERNAME:=$(whoami)}
export PACKAGE_NAME=${PACKAGE_NAME:=ruby}
export PACKAGE_VERSION=${PACKAGE_VERSION:=2.6.0}
export BASE_IMAGE=${BASE_IMAGE:="centos:7.6.1810"}
export IMAGE_NAME=${IMAGE_NAME:="centos7.6"}

# remove previously built local images
docker image rmi $DOCKER_USERNAME/$PACKAGE:$PACKAGE_VERSION-$IMAGE_NAME-$(date -u '+%Y%m%d') -f  || true
docker image rmi $DOCKER_USERNAME/$PACKAGE:$PACKAGE_VERSION-$IMAGE_NAME -f  || true
docker container rm $PACKAGE_VERSION-$IMAGE_NAME -f || true



# run Packer
cd ./packer-build
packer validate \
  -var build_date=$BUILD_DATE \
  -var base_image=$BASE_IMAGE \
  -var image_name=$IMAGE_NAME \
  -var docker_username=$DOCKER_USERNAME \
  -var package_name=$PACKAGE_NAME \
  -var package_version=$PACKAGE_VERSION \
  -var ansible_host=$IMAGE_NAME-$PACKAGE_NAME-$BUILD_DATE \
  packer_docker.json

packer build -force \
  -var build_date=$BUILD_DATE \
  -var base_image=$BASE_IMAGE \
  -var image_name=$IMAGE_NAME \
  -var docker_username=$DOCKER_USERNAME \
  -var package_name=$PACKAGE_NAME \
  -var package_version=$PACKAGE_VERSION \
  -var ansible_host=$PACKAGE_NAME-$PACKAGE_VERSION-$IMAGE_NAME-$BUILD_DATE \
  packer_docker.json

end=`date +%s`
secs=$((end-start))
printf 'runtime = %02dh:%02dm:%02ds\n' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))



# test the Docker image w/ Serverspec
rspec ../spec/Dockerfile_$IMAGE_NAME.rb

# push images
docker push $DOCKER_USERNAME/$PACKAGE:$PACKAGE_VERSION-$IMAGE_NAME-$(date -u '+%Y%m%d');
docker push $DOCKER_USERNAME/$PACKAGE:$PACKAGE_VERSION-$IMAGE_NAME;

end=`date +%s`
secs=$((end-start))
printf 'runtime = %02dh:%02dm:%02ds\n' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))
