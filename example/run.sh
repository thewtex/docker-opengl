#!/bin/sh

script_dir="`cd $(dirname $0); pwd`"

$script_dir/../run.sh -c opengl-example -i thewtex/opengl-example -p 6081
