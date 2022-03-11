ARG base_image

FROM spark-cluster:${base_image}

ARG jupyterlab_version=3.2.9
ARG spark_version=3.2.1

RUN apt-get update -y && apt-get clean
RUN apt-get install -y python3-pip
RUN /usr/bin/python3 -m pip install --upgrade pip
RUN pip3 install pip-tools jupyterlab==${jupyterlab_version} pyspark==${spark_version}

ENV PIP_DISABLE_PIP_VERSION_CHECK=1

EXPOSE 8888

WORKDIR ${SHARED_WORKSPACE}

CMD jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=