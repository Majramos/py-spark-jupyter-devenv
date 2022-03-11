ARG debian_buster_image_tag=11-jre-slim

# builder step used to download and configure environment
FROM openjdk:${debian_buster_image_tag} as builder

ARG spark_version=3.2.1
ARG hadoop_version=3.2
ARG python_version=3.9

# Add Dependencies for PySpark
RUN apt-get update -y && \
    apt-get install -y curl && \
    apt-get install -y python${python_version} && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    rm -rf /var/lib/apt/lists/*

ENV SHARED_WORKSPACE=/opt/workspace \
    SPARK_HOME=/opt/spark \
    PYTHONHASHSEED=1

VOLUME /opt/workspace

# Download and uncompress spark from the apache archive
RUN mkdir -p /opt/spark && \
    curl "https://archive.apache.org/dist/spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop${hadoop_version}.tgz" -o spark.tgz && \
    tar -xf spark.tgz -C /opt/spark --strip-components=1 && \
    rm spark.tgz


# Apache spark environment
FROM builder as spark-cluster

WORKDIR /opt/spark

ENV SPARK_MASTER_HOST=spark-master \
    SPARK_MASTER_PORT=7077 \
    SPARK_MASTER_WEBUI_PORT=8080 \
    SPARK_WORKER_WEBUI_PORT=8080 \
    SPARK_LOG_DIR=/opt/spark/logs \
    SPARK_MASTER_LOG=/opt/spark/logs/spark-master.out \
    SPARK_WORKER_LOG=/opt/spark/logs/spark-worker.out \
    SPARK_WORKLOAD="master" \
    PYSPARK_PYTHON=python3

EXPOSE 8080 7077

# Build log storage
RUN mkdir -p $SPARK_LOG_DIR && \
    touch $SPARK_MASTER_LOG && \
    touch $SPARK_WORKER_LOG && \
    ln -sf /dev/stdout $SPARK_MASTER_LOG && \
    ln -sf /dev/stdout $SPARK_WORKER_LOG

# File to startup diferent spark nodes
COPY /start-spark.sh /

CMD ["/bin/bash", "/start-spark.sh"]
