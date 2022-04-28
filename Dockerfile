FROM debian:11-slim as build

ARG ORTOOLS_VERSION

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get -y install \
      git \
      wget \
      pkg-config \
      build-essential \
      cmake \
      autoconf \
      libtool \
      zlib1g-dev \
      lsb-release

RUN mkdir -p /opt/or-tools && \
      cd /opt/or-tools && \
      git clone -b stable https://github.com/google/or-tools src 

WORKDIR /opt/or-tools/src

RUN git fetch --all --tags --prune && \
      git checkout tags/$ORTOOLS_VERSION -b $ORTOOLS_VERSION && \
      mkdir build && \
      cd build && \
      cmake -DBUILD_DEPS=ON -DCMAKE_INSTALL_PREFIX=/opt/or-tools .. && \
      make && \
      make test && \
      make install
