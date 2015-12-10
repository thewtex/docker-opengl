FROM thewtex/opengl:latest
MAINTAINER Matt McCormick <matt.mccormick@kitware.com>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  mesa-utils

ENV GRAPHICAL_APP "glxgears"
