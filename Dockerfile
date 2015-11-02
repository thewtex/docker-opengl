FROM debian:8
MAINTAINER Matt McCormick <matt.mccormick@kitware.com>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  git \
  libgl1-mesa-dri \
  mesa-utils \
  openbox \
  supervisor \
  x11vnc \
  xinit \
  xserver-xorg-video-dummy \
  xserver-xorg-input-void \
  websockify && \
  rm -f /usr/share/applications/x11vnc.desktop

COPY etc /etc

RUN useradd -m -s /bin/bash user
USER user

RUN mkdir -p /home/user/src
WORKDIR /home/user/src
RUN git clone https://github.com/kanaka/noVNC.git && \
  cd noVNC && \
  git checkout 6a90803feb124791960e3962e328aa3cfb729aeb

USER root
WORKDIR /root
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
