#!/bin/sh

show_help() {
cat << EOF
Usage: ${0##*/} [-h] [-c CONTAINER] [-i IMAGE]

This script is a convenience script to run Docker images based on
thewtex/opengl. It:

- Makes sure docker is available
- On Windows and Mac OSX, creates a docker machine if required
- Informs the user of the URL to access the container with a web browser
- Stops and removes containers from previous runs to avoid conflicts
- Mounts the present working directory to /home/user/work on Linux and Mac OSX

Options:

  -h             Display this help and exit
  -c             Container name to use (default opengl)
  -i             Image name (default thewtex/opengl)
  -p             Port to expose HTTP server (default 6080), if an empty
                 string, the port is not exposed
EOF
}

container=opengl
image=thewtex/opengl
port=6080

while [ $# -gt 0 ]; do
	case "$1" in
		-h)
			show_help
			exit 0
			;;
		-c)
			container=$2
			shift
			;;
		-i)
			image=$2
			shift
			;;
		-p)
			port=$2
			shift
			;;
		'?')
			show_help >&2
			exit 1
			;;
	esac
	shift
done


which docker 2>&1 >/dev/null
if [ $? -ne 0 ]; then
	echo "Error: the 'docker' command was not found.  Please install docker."
	exit 1
fi

os=$(uname)
if [ "${os}" != "Linux" ]; then
	vm=$(docker-machine active 2> /dev/null || echo "default")
	if ! docker-machine inspect "${vm}" &> /dev/null; then
		echo "Creating machine ${vm}..."
		docker-machine -D create -d virtualbox --virtualbox-memory 2048 ${vm}
	fi
	docker-machine start ${vm} > /dev/null
    eval $(docker-machine env $vm --shell=sh)
fi

ip=$(docker-machine ip ${vm} 2> /dev/null || echo "localhost")
url="http://${ip}:$port"

running=$(docker ps -a -q --filter "name=${container}")
if [ -n "$running" ]; then
	echo "Stopping and removing the previous session..."
	echo ""
	docker stop $container >/dev/null
	docker rm $container >/dev/null
fi

echo ""
echo "Setting up the graphical application container..."
echo ""
echo "Point your web browser to ${url}"
echo ""

pwd_dir="$(pwd)"
mount_local=""
if [ "${os}" = "Linux" ] || [ "${os}" = "Darwin" ]; then
	mount_local=" -v ${pwd_dir}:/home/user/work "
fi
port_arg=""
if [ -n "$port" ]; then
	port_arg="-p $port:6080"
fi

docker run \
  -d \
  --name $container \
  ${mount_local} \
  $port_arg \
  $image >/dev/null

result=$(docker wait $container)

docker cp $container:/var/log/supervisor/graphical-app-launcher.log - | tar xO
exit $result

# vim: noexpandtab shiftwidth=4 tabstop=4 softtabstop=0
