#!/bin/sh

script_dir="`cd $(dirname $0); pwd`"

docker build -t slicer/opengl $script_dir
