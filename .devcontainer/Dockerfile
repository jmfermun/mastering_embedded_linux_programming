# Pull base image. 
FROM ubuntu:latest

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

# Create non root user.
ARG USERNAME=user-docker
ARG USER_UID=1001
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Set the default user. Omit if you want to keep the default as root.
USER $USERNAME

# Default command to be executed.
CMD ["/bin/bash"]
