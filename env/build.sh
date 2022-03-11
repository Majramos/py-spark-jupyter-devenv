#!/bin/bash

# -- Software Stack Version

JAVA_VERSION="11"
SPARK_VERSION="3.2.1"
HADOOP_VERSION="3.2"
PYTHON_VERSION="3.9"
JUPYTERLAB_VERSION="3.2.9"
IMAGE_TAG="java${JAVA_VERSION}-spark${SPARK_VERSION}-hadoop${HADOOP_VERSION}"

# -- Building the Images

# spark-cluster
docker build \
  --build-arg debian_buster_image_tag="${JAVA_VERSION}-jre-slim" \
  --build-arg spark_version="${SPARK_VERSION}" \
  --build-arg hadoop_version="${HADOOP_VERSION}" \
  --build-arg python_version="${PYTHON_VERSION}" \
  -f spark-cluster.Dockerfile \
  -t spark-cluster:"${IMAGE_TAG}" .

# jupyter lab
docker build \
  --build-arg base_image="${IMAGE_TAG}" \
  --build-arg spark_version="${SPARK_VERSION}" \
  --build-arg jupyterlab_version="${JUPYTERLAB_VERSION}" \
  -f jupyterlab.Dockerfile \
  -t spark-jupyterlab:"py${PYTHON_VERSION}-jupyterlab${JUPYTERLAB_VERSION}-spark${SPARK_VERSION}" .

echo "Press enter to exit..."
read