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
# ENVIRONMENTS

Environment | Default|Description
---|---|---
KAFKA_USER|kafka |User to run kafka-connect
KAFKA_GROUP|kafka| User group to run kafka-connect
KAFKA_HOME|/opt/kafka/| Kafka connect root directory
CONNECTOR_DIR|/opt/connectors| connectors directory
REST_PORT|8083| Connect rest api port
BOOTSTRAP_SERVERS|127.0.0.1:9092| Connect kafka servers
GROUP_ID|connect-cluster| Worker groupId
OFFSET_STORAGE_TOPIC|connect-offsets| Name of the topic to store connect offsets
CONFIG_STORAGE_TOPIC|connect-configs|Name of the topic to store connect config
STATUS_STORAGE_TOPIC|connect-status\|Name of the topic to store connect status
OFFSET_STORAGE_RF|1| Replication factor for OFFSET_STORAGE_TOPIC
CONFIG_STORAGE_RF|1| Replication factor for CONFIG_STORAGE_TOPIC
STATUS_STORAGE_RF|1| Replication factor for STATUS_STORAGE_TOPIC
OFFSET_FLUSH_INTERVAL|10000| Interval in milliseconds to flush 
