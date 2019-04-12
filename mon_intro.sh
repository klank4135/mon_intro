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

function start_jaeger(){
echo "Starting Jaeger Container"
docker run -d --name jaeger \
	-e COLLECTOR_ZIPKIN_HTTP_PORT=9411 \
  	-p 5775:5775/udp \
  	-p 6831:6831/udp \
  	-p 6832:6832/udp \
  	-p 5778:5778 \
  	-p 16686:16686 \
  	-p 14268:14268 \
  	-p 9411:9411 \
  	jaegertracing/all-in-one:1.8

echo "Starting Demo Application"
docker run -d --name jaeger_hotrod \
  --link jaeger \
  -p8880-8883:8080-8083 \
  -e JAEGER_AGENT_HOST="jaeger" \
  jaegertracing/example-hotrod:1.8 \
  all
}

function setup_logs(){

	echo "Starting a Demo App to create demo logs"
	git clone https://github.com/chentex/random-logger $workdir/random-logger
	cd $workdir/random-logger && docker-compose up -d

	echo "Adding my_awesome.log file on my_awesome.log"
	docker logs -f random-logger_random-logger_1 > $workdir/my_awesome.log &

	echo "Adding my_awesome.log contents into Logstash on http://localhost:5000/"
	nc localhost 5000 < $workdir/my_awesome.log&

	sleep .30

	echo "Starting Kibana with a default index-pattern"
	curl -XPOST -D- 'http://localhost:5601/api/saved_objects/index-pattern' \
    -H 'Content-Type: text/plain' \
    -H 'kbn-version: 6.6.1' \
    -d '{"attributes":{"title":"logstash-*","timeFieldName":"@timestamp"}}'
}

function stop_docker_elk(){

echo "Stop and remove Docker ELK projects"
cd $workdir/docker-elk && docker-compose stop

}

function stop_mon_talk(){

echo "Stop and remove Docker Mon-Intro projects"
cd $workdir/mon-talk && docker-compose stop

}

function stop_jaeger(){

echo "Stop and remove Jaeger Docker Containers"

docker stop jaeger
docker rm -f jaeger
docker stop jaeger_hotrod
docker rm -f jaeger_hotrod
}

if [ "$@" == "start" ]; then
	start_docker_elk
	start_mon_talk
	start_jaeger
elif [ "$@" == "stop" ]; then
	stop_docker_elk
	stop_mon_talk
	stop_jaeger
elif [ "$@" == "setup" ]; then
	setup_logs
fi
