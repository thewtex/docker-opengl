#!/bin/sh

# This script is a convenience script to run the container. It:
#
# - Makes sure docker is available
# - On Windows and Mac OSX, creates a docker machine if required
# - Informs the user of the URL to access the container with a web browser
# - Stops and removes containers from previous runs to avoid conflicts
# - Mounts the present working directory to /home/user/work on Linux and Mac OSX

which docker 2>&1 >/dev/null
if [ $? -ne 0 ]; then
	echo "Error: the 'docker' command was not found.  Please install docker."
	exit 1
fi

_OS=$(uname)
if [ "${_OS}" != "Linux" ]; then
	_VM=$(docker-machine active 2> /dev/null || echo "default")
	if ! docker-machine inspect "${_VM}" &> /dev/null; then
		echo "Creating machine ${_VM}..."
		docker-machine -D create -d virtualbox --virtualbox-memory 2048 ${_VM}
	fi
	docker-machine start ${_VM} > /dev/null
    eval $(docker-machine env $_VM --shell=sh)
fi

_IP=$(docker-machine ip ${_VM} 2> /dev/null || echo "localhost")
_URL="http://${_IP}:6080"

_RUNNING=$(docker ps -a -q --filter "name=opengl")
if [ -n "$_RUNNING" ]; then
	echo "Stopping and removing the previous session..."
	echo ""
	docker stop opengl >/dev/null
	docker rm opengl >/dev/null
fi

echo ""
echo "Setting up the graphical application container..."
echo ""
echo "Point your web browser to ${_URL}"
echo ""

_PWD_DIR="$(pwd)"
_MOUNT_LOCAL=""
if [ "${_OS}" = "Linux" ] || [ "${_OS}" = "Darwin" ]; then
	_MOUNT_LOCAL=" -v ${_PWD_DIR}:/home/user/work "
fi
docker run \
  -d \
  --name opengl \
  ${_MOUNT_LOCAL} \
  -p 6080:6080 \
  thewtex/opengl >/dev/null

result=$(docker wait opengl)

docker cp opengl:/var/log/supervisor/graphical-app-launcher.log /tmp/docker-opengl-graphical-app.log
cat /tmp/docker-opengl-graphical-app.log
rm /tmp/docker-opengl-graphical-app.log
exit $result

# vim: noexpandtab shiftwidth=4 tabstop=4 softtabstop=0
