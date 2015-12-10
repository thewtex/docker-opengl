#!/bin/sh

script_dir="`cd $(dirname $0); pwd`"

docker build -t thewtex/opengl-example $script_dir
