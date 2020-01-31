FROM alpine as downloader

ENV KAFKA_TARBALL=https://www-eu.apache.org/dist/kafka/2.4.0/kafka_2.11-2.4.0.tgz
#Better to keep this on a separate layer :D
RUN apk --no-cache add curl

RUN mkdir -p /apps/kafka && \
    curl ${KAFKA_TARBALL} -o /apps/kafka.tar.gz && \
    tar -xvzf /apps/kafka.tar.gz -C /apps/kafka --strip-components 1

FROM adoptopenjdk/openjdk8:alpine-slim

ENV KAFKA_USER=kafka \
    KAFKA_GROUP=kafka \
    KAFKA_HOME=/opt/kafka/ \
    CONNECTOR_DIR=/opt/connectors \
    REST_PORT=8083 \
    BOOTSTRAP_SERVERS=127.0.0.1:9092 \
    GROUP_ID=connect-cluster \
    OFFSET_STORAGE_TOPIC=connect-offsets \
    CONFIG_STORAGE_TOPIC=connect-configs \
    STATUS_STORAGE_TOPIC=connect-status \
    OFFSET_STORAGE_RF=1 \
    CONFIG_STORAGE_RF=1 \
    STATUS_STORAGE_RF=1 \
    OFFSET_FLUSH_INTERVAL=10000

RUN apk update && \
    apk --no-cache add bash && \
    mkdir -p ${KAFKA_HOME} && \
    mkdir -p ${CONNECTOR_DIR} && \
    addgroup ${KAFKA_GROUP} && \
    adduser -h ${KAFKA_HOME} -D -s /bin/bash -G ${KAFKA_GROUP} ${KAFKA_USER} && \
    chown -R ${KAFKA_USER}:${KAFKA_GROUP} ${KAFKA_HOME} ${KAFKA_HOME}

COPY --from=downloader /apps/kafka ${KAFKA_HOME}

COPY entrypoint.sh ${KAFKA_HOME}

RUN chown ${KAFKA_USER}:${KAFKA_GROUP} ${KAFKA_HOME}/entrypoint.sh && \
    chmod +x ${KAFKA_HOME}/entrypoint.sh

USER ${KAFKA_USER}

EXPOSE ${REST_PORT}

WORKDIR ${KAFKA_HOME}

CMD ["/bin/bash", "-c", "./entrypoint.sh"]