# packer-ruby

Packer, Ansible, Serverspec, project to create a Ruby Docker images, based on CentOS 7.4

## Requirements

- Packer
- Ansible
- [Serverspec](https://serverspec.org/): gem install serverspec
- [docker-api](https://github.com/swipely/docker-api/releases): gem install docker-api

## Install
```shell
git clone --recurse-submodules https://github.com/apolloclark/packer-ruby
cd ./packer-ruby

# update submodules
git submodule update --recursive --remote

# set your Docker hub username
export DOCKER_USERNAME="apolloclark" # $(whoami)
export DOCKER_PASSWORD=""

# build both the Ubuntu 16.04 and Centos 7.6 images
./build_packer_docker_all.sh



# clean up ALL previous builds
./clean_packer_docker.sh

# Gradle, clean up previous builds, from today
gradle clean --parallel --project-dir gradle-build

# Gradle, build all images, in parallel
gradle testAnsible --parallel --project-dir gradle-build

# Gradle, build all images, in parallel, forced rebuild
gradle testAnsible --parallel --rerun-tasks --project-dir gradle-build

# Gradle, build only specific OS images
gradle ubuntu18.04:testAnsible --project-dir gradle-build
gradle ubuntu16.04:testAnsible --project-dir gradle-build
gradle centos7:testAnsible --project-dir gradle-build

# Gradle, build only specific OS images, forced rebuild
gradle ubuntu18.04:testAnsible --rerun-tasks --project-dir gradle-build
gradle ubuntu16.04:testAnsible --rerun-tasks --project-dir gradle-build
gradle centos7:testAnsible --rerun-tasks --project-dir gradle-build



# Gradle, list tasks, and dependency graph
gradle tasks --project-dir gradle-build
gradle tasks --all --project-dir gradle-build
gradle test taskTree --project-dir gradle-build
gradle buildParallel taskTree --project-dir gradle-build

# Gradle, debug
gradle properties

gradle ubuntu16.04:info --project-dir gradle-build

gradle ubuntu16.04:test --project-dir gradle-build --info --rerun-tasks

rm -rf ~/.gradle
```

## Build Details

```shell
RVM, 1.29.9, 2019-07-09
https://github.com/rvm/rvm/releases

Ruby, 2.6.3, 2019-04-17
https://www.ruby-lang.org/en/downloads/releases/

Serverspec, 2.41.4, 2019-05-17
https://github.com/mizzy/serverspec/releases

Infrataster, 0.3.2, 2015-11-19
https://github.com/ryotarai/infrataster/releases
```