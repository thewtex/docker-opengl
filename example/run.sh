#!/bin/sh

script_dir="`cd $(dirname $0); pwd`"

$script_dir/../run.sh -c opengl-example -i thewtex/opengl-example:centos-v1.0.0 -p 6081 "$@"
