FROM debian:8
MAINTAINER Matt McCormick <matt.mccormick@kitware.com>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  git \
  libgl1-mesa-dri \
  mesa-utils \
  openbox \
  supervisor \
  x11vnc \
  xserver-xorg-video-dummy \
  xserver-xorg-input-void \
  websockify && \
  rm -f /usr/share/applications/x11vnc.desktop

WORKDIR /usr/src
RUN git clone https://github.com/kanaka/noVNC.git && \
  cd noVNC && \
  git checkout 6a90803feb124791960e3962e328aa3cfb729aeb

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
