FROM alpine as downloader
RUN apk add curl
RUN mkdir -p /apps/kafka && \
    curl https://www-eu.apache.org/dist/kafka/2.4.0/kafka_2.11-2.4.0.tgz \
    -o /apps/kafka.tar.gz
RUN tar -xvzf /apps/kafka.tar.gz -C /apps/kafka --strip-components 1
FROM adoptopenjdk/openjdk8:alpine-slim

RUN apk update && \
    apk add bash && \
    mkdir -p /opt/kafka && \
    mkdir -p /opt/connectors

COPY --from=downloader /apps/kafka /opt/kafka/

COPY connect-distributed.properties /opt/kafka/

ENV BOOTSTRAP_SERVERS=127.0.0.1:9092 \
    GROUP_ID=111 \
    OFFSET_STORAGE_TOPIC=SS \
    CONFIG_STORAGE_TOPIC=xxx \
    OFFSET_FLUSH_INTERVAL=10000 \
    REST_PORT=8083 \
    KAFKA_HOME=/opt/kafka

WORKDIR ${KAFKA_HOME}

CMD ["/bin/bash", "-c", "./bin/connect-distributed.sh ./connect-distributed.properties"]