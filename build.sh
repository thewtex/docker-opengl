#!/bin/sh

script_dir="`cd $(dirname $0); pwd`"

docker build -t thewtex/opengl:centos-2016.10.20 $script_dir
