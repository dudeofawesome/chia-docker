FROM ubuntu:latest

EXPOSE 8555
EXPOSE 8444

ENV keys="generate"
ENV harvester="false"
ENV farmer="false"
ENV plots_dir="/plots"
ENV farmer_address="null"
ENV farmer_port="null"
ENV testnet="false"
ENV full_node_port="null"
ENV self_hostname="127.0.0.1"
ENV TZ="UTC"

RUN DEBIAN_FRONTEND=noninteractive apt-get update \
&& DEBIAN_FRONTEND=noninteractive apt-get install -y \
  curl \
  python3 \
  ansible \
  ca-certificates \
  git \
  openssl \
  python3-pip \
  sudo \
  build-essential \
  python3-dev \
  python3.8-venv \
  python3.8-distutils \
  apt \
  tzdata

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

ARG BRANCH=main

RUN echo "cloning ${BRANCH}"
RUN git clone --branch ${BRANCH} https://github.com/Chia-Network/chia-blockchain.git \
&& cd chia-blockchain \
&& git submodule update --init mozilla-ca \
&& /usr/bin/sh ./install.sh

ENV PATH=/chia-blockchain/venv/bin:$PATH
WORKDIR /chia-blockchain
ADD ./entrypoint.sh /entrypoint.sh

ENTRYPOINT ["bash", "/entrypoint.sh"]
