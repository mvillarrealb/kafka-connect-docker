# /bin/bash

cat > ./connect-distributed.properties <<EOL
bootstrap.servers=$BOOTSTRAP_SERVERS
group.id=$GROUP_ID

key.converter=org.apache.kafka.connect.json.JsonConverter
value.converter=org.apache.kafka.connect.json.JsonConverter

key.converter.schemas.enable=true
value.converter.schemas.enable=true

offset.storage.topic=$OFFSET_STORAGE_TOPIC
offset.storage.replication.factor=$OFFSET_STORAGE_RF
#offset.storage.partitions=25

config.storage.topic=$CONFIG_STORAGE_TOPIC
config.storage.replication.factor=$CONFIG_STORAGE_RF

status.storage.topic=$STATUS_STORAGE_TOPIC
status.storage.replication.factor=$STATUS_STORAGE_RF
#status.storage.partitions=5

offset.flush.interval.ms=$OFFSET_FLUSH_INTERVAL

rest.port=$REST_PORT

plugin.path=/opt/connectors
EOL

./bin/connect-distributed.sh ./connect-distributed.properties