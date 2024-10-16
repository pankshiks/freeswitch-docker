# Use the official Debian slim image as a base
FROM debian:bullseye-slim

# Set the working directory
WORKDIR /usr/local/src/

# Install necessary packages
RUN apt-get update && \
    apt-get install -y \
        build-essential \
        git \
        wget \
        curl \
        libssl-dev \
        libtool \
        pkg-config \
        uuid-dev \
        zlib1g-dev \
        libjpeg-dev \
        libsqlite3-dev \
        libcurl4-openssl-dev \
        libpcre3-dev \
        libspeexdsp-dev \
        libldns-dev \
        libedit-dev \
        libtiff5-dev \
        yasm \
        libopus-dev \
        libsndfile1-dev \
        unzip \
        libavformat-dev \
        libswscale-dev \
        liblua5.2-dev \
        liblua5.2-0 \
        cmake \
        libpq-dev \
        unixodbc-dev \
        autoconf \
        automake \
        ntpdate \
        libxml2-dev \
        lua5.2 \
        lua5.2-doc \
        libreadline-dev \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Install libspandsp
RUN git clone https://github.com/freeswitch/spandsp.git /usr/local/src/spandsp && \
    cd /usr/local/src/spandsp && \
    ./bootstrap.sh && \
    ./configure && \
    make && \
    make install

# Continue with the rest of the installation as needed...
