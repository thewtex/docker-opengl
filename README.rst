docker-opengl
=============
A docker image that supports testing WebGL applications.

.. image:: https://circleci.com/gh/thewtex/docker-opengl.svg?style=svg
    :target: https://circleci.com/gh/thewtex/docker-opengl

.. image:: https://images.microbadger.com/badges/image/thewtex/opengl.svg
  :target: https://microbadger.com/images/thewtex/opengl

Overview
--------

This image supports running the `napari <https://napari.org>`_ image viewer.

This Docker image supports portable, CPU-based graphical application
rendering, including rendering OpenGL-based applications. An X session is
running on display ``:0`` and can be viewed through HTML5 viewer on any device
with a modern web browser (Mac OSX, Windows, Linux, Android, iOS, ChromeOS,
...). The graphical interface running in a Docker container or can be debugged
by visiting a VNC session exposed over a local HTTP port.

Quick-start
-----------

Execute the ``run.sh`` script from your npm package folder.

Details
--------

By default, the ``run.sh`` script executes ``npm run test`` command in the mounted
current directory.

On application exit, the ``run.sh`` will print the command's console output and
exit with the command's return code.

To debug, pass the ``-d`` flag, which will start up the graphical session and
points you to a URL on the local host where you can view and interact with the
session.

The session runs `Openbox <http://openbox.org>`_ as a non-root user, *user*
that has password-less sudo privileges. The browser view is an HTML5 viewer
that talks over websockets to a VNC Server. The VNC Server displays a running
Xdummy session.

To customize the test command, create a local shell script that executes the
desired command, then specify it with ``-r --env=APP=test/my-test-command.sh``.

The ``run.sh`` script can be used to drive start-up. It is customizable with
flags: see ``run.sh -h`` for details.

Credits
-------

This configuration was largely inspired by the `dit4c project <https://dit4c.github.io>`_.
