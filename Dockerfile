FROM thewtex/centos-build:v1.0.0
MAINTAINER Mayeul Chassagnard <mayeul.chassagnard@kitware.com> Jean-Christophe Fillion-Robin <jchris.fillionr@kitware.com>

RUN yum update -y && \
  yum install -y \
  mesa-libGL \
  net-tools \
  sudo \
  xorg-x11-server-utils \
  xorg-x11-server-Xvnc-source \
  xorg-x11-xinit \
  xorg-x11-drv-dummy \
  xorg-x11-drv-void

RUN wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py && \
  python get-pip.py

RUN rm -f /usr/share/applications/x11vnc.desktop && \
  pip install websockify supervisor supervisor-stdout && \
  mkdir /var/log/supervisor/

# Following package are required for building x11vnc
RUN yum install -y \
  libjpeg-devel \
  libXcursor-devel \
  libXinerama-devel \
  libXrandr-devel \
  libXt-devel \
  libXtst-devel

RUN wget "http://downloads.sourceforge.net/project/libvncserver/x11vnc/0.9.13/x11vnc-0.9.13.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Flibvncserver%2Ffiles%2Fx11vnc%2F0.9.13%2F&ts=1475558391&use_mirror=heanet" && \
  tar -xzvf x11vnc-0.9.13.tar.gz && \
  cd x11vnc-0.9.13 && \
  ./configure && \
  make -j8 && \
  make install

COPY etc/skel/.xinitrc /etc/skel/.xinitrc

RUN useradd -m -s /bin/bash user
USER user

RUN cp /etc/skel/.xinitrc /home/user/
USER root
RUN echo "user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers

RUN git clone https://github.com/kanaka/noVNC.git /opt/noVNC && \
  cd /opt/noVNC && \
  git checkout 6a90803feb124791960e3962e328aa3cfb729aeb && \
  ln -s vnc_auto.html index.html

# Install OpenBox
RUN wget ftp://ftp.pbone.net/mirror/centos.karan.org/el5/extras/testing/x86_64/RPMS/openbox-libs-3.4.7.2-5.el5.kb.x86_64.rpm && \
  wget ftp://ftp.pbone.net/mirror/centos.karan.org/el5/extras/testing/x86_64/RPMS/openbox-3.4.7.2-5.el5.kb.x86_64.rpm && \
  yum install --nogpgcheck -y openbox*.rpm

# Following package are required for building x11vnc
RUN yum install -y \
  mesa-libGLU

RUN cd x11vnc-0.9.13 && \
  ./x11vnc/misc/Xdummy && \
  ./x11vnc/misc/Xdummy -install && \
  cp ./x11vnc/misc/Xdummy /usr/local/bin/ && \
  cp ./x11vnc/misc/Xdummy.so /usr/local/bin/


###############################################
# Pre-requisites to build the X_Window_System #
###############################################

WORKDIR /root

RUN yum install -y \
  ack-grep \
  vim

RUN curl http://beyondgrep.com/ack-2.12-single-file > /bin/ack && chmod 0755 /bin/ack

# Update to autoconf-2.69
RUN wget --no-check-certificate http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz && \
  tar xvfvz autoconf-2.69.tar.gz && \
  cd autoconf-2.69 && \
  ./configure && \
  make && \
  make install

# install libtool 2.4.6
RUN yum erase -y libtool && \
  wget --no-check-certificate http://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.gz && \
  tar -xzvf libtool-2.4.6.tar.gz && \
  cd libtool-2.4.6 && \
  ./configure && \
  make && \
  make install


###########################################
# Building_the_X_Window_System for centOS #
###########################################
#
# https://www.x.org/wiki/Building_the_X_Window_System/#buildprocessbasedonbuild.shscript
#

WORKDIR /root

RUN mkdir src && \
  git clone git://anongit.freedesktop.org/git/xorg/util/modular src/util/modular && \
  mkdir build

# XXX This hack is required to ensure autoconf can find libtool macros.
# Without it the following error was reported during the building of lib/libXau :
#  configure.ac:35: error: possibly undefined macro: AC_LIBTOOL_WIN32_DLL
#      If this token and others are legitimate, please use m4_pattern_allow.
#      See the Autoconf documentation.
#  configure.ac:36: error: possibly undefined macro: AC_PROG_LIBTOOL
RUN mkdir -p build/share && \
  cd build/share/ && \
  ln -s /usr/local/share/aclocal/ aclocal

# Install the newer version of X11 ::: Still an error during lib/libx11
#RUN cd src && \
#  ./util/modular/build.sh --clone $HOME/build

###########################################
###########################################

# noVNC (http server) is on 6080, and the VNC server is on 5900
EXPOSE 6080 5900

COPY etc /etc
COPY usr /usr

ENV DISPLAY :0

WORKDIR /root

CMD ["/usr/local/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
