# Pull base image. 
FROM ubuntu:20.04

# Update the base image.
RUN apt-get update && apt-get upgrade -y

# Set the time zone and locale.
ENV TZ=Europe/Brussels
ENV LC_ALL=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LANG=en_US.UTF-8

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && apt-get install -y locales \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8

# Install tools.
RUN apt-get install -y \
    autoconf \
    automake \
    bison \
    bzip2 \
    cmake \
    flex\
    g++ \
    gawk \
    gcc \
    gettext \
    git \
    gperf \
    help2man \
    libncurses5-dev \
    libstdc++6 \
    libtool \
    libtool-bin make \
    patch \
    python3-dev \
    rsync \
    texinfo \
    unzip \
    wget \
    xz-utils
