# kafka-connect-docker(In progress)

Dockerized kafka connect

# Build the image

To build the docker image simply use(multi stage build must be supported):

```sh
docker build -t kafka-connect-server:0.0.2 .
```

# Run kafka-connect worker

To run a simple kafka-connect worker

```sh
docker run -p 8083:8083 --network host kafka-connect-server:0.0.2
```
# Run with connector mount

To run a kafka-connect worker with a mount for connector just reference
the volume located in /opt/connectors, and reference it with your host
connectors path

```sh
docker run -p 8083:8083 --network host -v ~/kafka-connect/connectors:/opt/connectors kafka-connect-server:0.0.2
```

# ROADMAP

* Make externalizable or use environment to configure connect.properties

* Add compose example with kafka-connect-ui

* Add compose with a kafka cluster