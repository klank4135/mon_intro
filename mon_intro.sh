#!/bin/bash
echo "##### Welcome to mon_intro project #####"

function start_docker_elk(){
echo "Downloading the Docker projects"
delk="docker-elk"
	if [ -d "$delk" ]
	then
		echo "$delk repository found."
		echo "Building and starting docker-elk stack"
	else
		echo "Cloning the repository https://github.com/deviantony/docker-elk.git"
		git clone https://github.com/deviantony/docker-elk.git
	fi

cd docker-elk && docker-compose up -d
}

function stop_docker_elk(){
echo "Stopping and removing Docker projects"
cd docker-elk && docker-compose stop
cd .. && rm -rf docker-elk
}


if [ "$@" == "start" ]
	then
    start_docker_elk
elif [ "$@" == "stop" ]
	then
	stop_docker_elk
fi
