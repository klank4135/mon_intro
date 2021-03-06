#!/bin/bash
workdir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)
echo "##### Welcome to mon_intro project #####"

function start_docker_elk(){
	echo "Starting ELK Stack"
	cd $workdir/docker-elk && docker-compose up -d
}

function start_mon_talk(){
	echo "Starting Metric apps (Grafana/Prometheous)"
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
	docker run -d --name random-json-logger sikwan/random-json-logger:latest

	echo "Adding my_awesome.log file on my_awesome.log"
	docker logs -f random-json-logger > ${workdir}/my_awesome.log &

	sleep 30
	echo "Adding my_awesome.log contents into Logstash on http://localhost:5000/"
	nc localhost 5000 < my_awesome.log &

	echo "Starting Kibana with a default index-pattern"
	curl -XPOST -D- 'http://localhost:5601/api/saved_objects/index-pattern' \
    -H 'Content-Type: application/json' \
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

function stop_logger(){
	echo "Stop and remove Logger Services"
	docker stop random-json-logger
	docker rm random-json-logger 
}

if [ "$@" == "start" ]; then
	start_docker_elk
	start_mon_talk
	start_jaeger
elif [ "$@" == "stop" ]; then
	stop_docker_elk
	stop_mon_talk
	stop_jaeger
	stop_logger
elif [ "$@" == "setup" ]; then
	setup_logs
fi
