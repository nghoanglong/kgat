FROM pytorch/pytorch:1.6.0-cuda10.1-cudnn7-devel

ENV LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 

RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub 208
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub

RUN mkdir -p /usr/share/man/man1 && \
    apt-get update && apt-get install -y \
    build-essential \
    cifs-utils \
    curl \
    default-jdk \
    dialog \
    dos2unix \
    git \
    sudo \
    wget \
    unzip \
    nano

# Install app requirements first to avoid invalidating the cache
WORKDIR /app

# Copy all files
COPY . /app/

# Install packages
RUN pip install -r requirements.txt

# Assume that the datasets will be mounted as a volume into /mnt/data on startup.
# Symlink the data subdirectory to that volume.
ENV CACHE_DIR=/mnt/data
RUN mkdir -p /mnt/data && \
    ln -snf /mnt/data /app/data

# Convert all shell scripts to Unix line endings, if any
RUN /bin/bash -c 'if compgen -G "/app/**/*.sh" > /dev/null; then dos2unix /app/**/*.sh; fi'

ENTRYPOINT bash
