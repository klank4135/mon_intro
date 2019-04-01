#!/bin/bash
workdir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
delk="docker-elk"
mtalk="mon-talk"

echo "##### Welcome to mon_intro project #####"

function start_docker_elk(){
echo "Downloading the Docker projects"
	if [ -d "$delk" ]; then
		echo "$delk repository found."
		echo "Building and starting docker-elk stack"
	else
		echo "Cloning the repository https://github.com/deviantony/docker-elk.git"
		git clone https://github.com/deviantony/docker-elk.git $workdir/docker-elk
	fi

cd $workdir/docker-elk && docker-compose up -d
}

function start_mon_talk(){
	if [ -d "$mtalk" ]; then
		echo "$mtalk repository found"
		echo "Building and starting Prometheous and Grafana Containers"
	else
		echo "Cloning the repository https://github.com/klank4135/mon-talk.git"
		git clone https://github.com/klank4135/mon-talk.git $workdir/mon-talk
	fi

cd $workdir/mon-talk && docker-compose up -d
}

function stop_docker_elk(){
echo "Stopping and removing Docker ELK projects"
cd $workdir/docker-elk && docker-compose stop
}

function stop_mon_talk(){
echo "Stopping and removing Docker Mon-Intro projects"
cd $workdir/mon-talk && docker-compose stop
}

if [ "$@" == "start" ]; then
	start_docker_elk
	start_mon_talk
elif [ "$@" == "stop" ]; then
	stop_docker_elk
	stop_mon_talk 
fi
