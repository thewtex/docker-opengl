FROM debian:8
MAINTAINER Matt McCormick <matt.mccormick@kitware.com>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  libgl1-mesa-dri \
  mesa-utils \
  openbox \
  supervisor \
  x11vnc \
  xserver-xorg-video-dummy \
  xserver-xorg-input-void \
  websockify && \
  rm -f /usr/share/applications/x11vnc.desktop

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
