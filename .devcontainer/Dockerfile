FROM debian:stretch

RUN apt-get update && apt-get -y install git curl unzip

RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /home/codespace
WORKDIR /home/codespace

ENV PUB_CACHE=/home/codespace/.pub_cache
ENV PATH="/home/codespace/flutter/bin:$PATH"

RUN curl -LO https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_2.10.1-stable.tar.xz
RUN tar xf flutter_linux_2.10.2-stable.tar.xz

RUN flutter doctor