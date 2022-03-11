#!/bin/bash

if [ "$SPARK_WORKLOAD" == "master" ];
then

# When the spark work_load is master run spark-class org.apache.spark.deploy.master.Master
cd /opt/spark/bin && ./spark-class org.apache.spark.deploy.master.Master --ip $SPARK_MASTER_HOST --port $SPARK_MASTER_PORT --webui-port $SPARK_MASTER_WEBUI_PORT >> $SPARK_MASTER_LOG

elif [ "$SPARK_WORKLOAD" == "worker" ];
then

# When the spark work_load is worker run spark-class org.apache.spark.deploy.master.Worker
cd /opt/spark/bin && ./spark-class org.apache.spark.deploy.worker.Worker spark://${SPARK_MASTER_HOST}:${SPARK_MASTER_PORT} --webui-port $SPARK_WORKER_WEBUI_PORT >> $SPARK_WORKER_LOG

else
    echo "Undefined Workload Type $SPARK_WORKLOAD, must specify: master, worker"
fi
