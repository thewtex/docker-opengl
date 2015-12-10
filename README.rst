docker-opengl
=============
A docker image that supports rendering graphical applications, including OpenGL apps.

.. image:: https://circleci.com/gh/thewtex/docker-opengl.svg?style=svg
    :target: https://circleci.com/gh/thewtex/docker-opengl

.. image:: https://badge.imagelayers.io/thewtex/opengl:latest.svg
  :target: https://imagelayers.io/?images=thewtex/opengl:latest

Overview
--------

This Docker image supports portable, CPU-based graphical application
rendering, including rendering OpenGL-based applications. An X session is
running on display `:0` and can be viewed through HTML5 viewer served at port
6080.

Quick-start
-----------

Execute the `run.sh` script.

Details
--------

To run manually::

  docker run --rm -p 6080:6080 thewtex/opengl

And go to `http://localhost:6080` (on Linux) to view and interact with the session.

The session runs `Openbox <http://openbox.org>`_ as a non-root user, *user*
that has password-less sudo privileges. The browser view is an HTML5 viewer
that talks over websockets to a VNC Server. The VNC Server displays a running
Xdummy session.

Credits
-------

This configuration was largely inspired by the `dit4c project <https://dit4c.github.io>`_.
