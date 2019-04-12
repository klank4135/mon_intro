# Monitoring Talk

A docker/docker-compose based setup to deploy Prometheus DB with node-exporter and Grafana UI

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to install the software and how to install them

```
docker
docker-compose
```

### Installing

A step by step series of examples that tell you have to get a development env running

Say what the step will be

```
git clone https://github.com/klank4135/mon-talk.git
cd mon-talk
# docker-compose up
```
If everything goes well, you well see something like this
```
grafana_1        | t=2018-04-13T22:19:43+0000 lvl=info msg="Initializing HTTP Server" logger=http.server address=0.0.0.0:3000 protocol=http subUrl= socket=
node-exporter_1  | time="2018-04-13T22:19:42Z" level=info msg=" - wifi" source="node_exporter.go:52"
node-exporter_1  | time="2018-04-13T22:19:42Z" level=info msg=" - textfile" source="node_exporter.go:52"
node-exporter_1  | time="2018-04-13T22:19:42Z" level=info msg=" - arp" source="node_exporter.go:52"
node-exporter_1  | time="2018-04-13T22:19:42Z" level=info msg=" - xfs" source="node_exporter.go:52"
node-exporter_1  | time="2018-04-13T22:19:42Z" level=info msg=" - timex" source="node_exporter.go:52"
node-exporter_1  | time="2018-04-13T22:19:42Z" level=info msg=" - hwmon" source="node_exporter.go:52"
node-exporter_1  | time="2018-04-13T22:19:42Z" level=info msg="Listening on :9100" source="node_exporter.go:76"
```

## Built With

* [docker](https://docker.com/) - Containerization tool
* [docker-compose](https://docs.docker.com/compose/) - Multi Container Management Tool
* [Prometheus](https://prometheus.io/) - Time Series Database
* [Node Exporter](https://github.com/prometheus/node_exporter) - Node Exporter Agent to scrape metrics
* [Grafana](https://grafana.com/) - Graphic UI with several datasources available to graph metrics


## Authors

* **Alexander Morales** - *Initial work* - [mon-talk](https://github.com/klank4135/mon-talk)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* [Finestructure] (https://finestructure.co/blog/2016/5/16/monitoring-with-prometheus-grafana-docker-part-1)
* For all the good information to take as base for this project