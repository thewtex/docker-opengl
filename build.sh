#!/bin/sh

script_dir="`cd $(dirname $0); pwd`"

image=thewtex/opengl:centos-2016.10.20

docker build -t $image \
    --build-arg IMAGE=$image \
    --build-arg VCS_REF=`git rev-parse --short HEAD` \
    --build-arg VCS_URL=`git config --get remote.origin.url` \
    --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
    $script_dir
