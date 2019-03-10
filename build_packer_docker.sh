#!/bin/bash -eux
start=`date +%s`

# ensure that ENV VARs are set
export DOCKER_USERNAME=${DOCKER_USERNAME:=$(whoami)}
echo "$DOCKER_USERNAME"
export PACKAGE=${PACKAGE:=ruby}
echo "$PACKAGE"
export PACKAGE_VERSION=${PACKAGE_VERSION:=2.6.1}
echo "$PACKAGE_VERSION"

# remove previously built local images
docker image rmi $DOCKER_USERNAME/$PACKAGE:$(date -u '+%Y%m%d') -f  || true
docker image rmi $DOCKER_USERNAME/$PACKAGE:$PACKAGE_VERSION -f  || true
docker image rmi $DOCKER_USERNAME/$PACKAGE -f  || true
docker container rm default -f || true

# run Packer
packer validate packer_docker.json
packer inspect packer_docker.json
packer build packer_docker.json

end=`date +%s`
secs=$((end-start))
printf 'runtime = %02dh:%02dm:%02ds\n' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))

# test the Docker image w/ Serverspec
#rspec ./spec/Dockerfile_ubuntu18.04.rb
#rspec ./spec/Dockerfile_centos7.4.rb
rspec ./spec/Dockerfile_amzlinux1.rb

# push images
docker push $DOCKER_USERNAME/$PACKAGE:$(date -u '+%Y%m%d');
docker push $DOCKER_USERNAME/$PACKAGE:$PACKAGE_VERSION;
docker push $DOCKER_USERNAME/$PACKAGE;

end=`date +%s`
secs=$((end-start))
printf 'runtime = %02dh:%02dm:%02ds\n' $(($secs/3600)) $(($secs%3600/60)) $(($secs%60))
