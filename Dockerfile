FROM ubuntu:16.04
MAINTAINER Matt McCormick <matt.mccormick@kitware.com>

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
  apt-transport-https \
  curl \
  git \
  libgl1-mesa-dri \
  menu \
  net-tools \
  openbox \
  python-pip \
  sudo \
  supervisor \
  tint2 \
  x11-xserver-utils \
  x11vnc \
  xinit \
  xserver-xorg-video-dummy \
  xserver-xorg-input-void \
  websockify \
  wget && \
  rm -f /usr/share/applications/x11vnc.desktop && \
  apt-get remove -y python-pip && \
  wget https://bootstrap.pypa.io/get-pip.py && \
  python get-pip.py && \
  pip install supervisor-stdout && \
  apt-get -y clean

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
  apt-get update && \
  apt-get install -y google-chrome-stable

RUN curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add - && \
  VERSION=node_11.x && DISTRO="xenial" && \
  echo "deb https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee /etc/apt/sources.list.d/nodesource.list && \
  echo "deb-src https://deb.nodesource.com/$VERSION $DISTRO main" | sudo tee -a /etc/apt/sources.list.d/nodesource.list && \
  sudo apt-get update && \
  sudo apt-get install -y nodejs

COPY etc/skel/.xinitrc /etc/skel/.xinitrc

RUN useradd -m -s /bin/bash user
USER user

RUN cp /etc/skel/.xinitrc /home/user/
USER root
RUN echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/user


RUN git clone https://github.com/kanaka/noVNC.git /opt/noVNC && \
  cd /opt/noVNC && \
  git checkout 6a90803feb124791960e3962e328aa3cfb729aeb && \
  ln -s vnc_auto.html index.html

# noVNC (http server) is on 6080, and the VNC server is on 5900
EXPOSE 6080 5900

COPY etc /etc
COPY usr /usr

ENV DISPLAY :0

WORKDIR /root

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]

# Build-time metadata as defined at http://label-schema.org
ARG BUILD_DATE
ARG IMAGE
ARG VCS_REF
ARG VCS_URL
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name=$IMAGE \
      org.label-schema.description="An image based on ubuntu:18.04 containing an X_Window_System which supports rendering graphical applications, including OpenGL apps" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.schema-version="1.0"
