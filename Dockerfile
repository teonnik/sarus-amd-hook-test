# Build stage with Spack pre-installed and ready to be used
FROM rocm/dev-ubuntu-20.04:4.5.2-complete as builder

# Basic tools: git, wget, tar
RUN apt-get -y update && \
    apt-get -y install --no-install-recommends \
    git \
    wget \
    tar \
    curl

# Install recent cmake version
RUN wget -qO- "https://cmake.org/files/v3.22/cmake-3.22.1-linux-x86_64.tar.gz" | \
    tar --strip-components=1 -xz -C /usr/local

# Install `sarus-amd-hook-test`
RUN export SRC_DIR=/opt/sarus-amd-hook-test && \
    git clone https://github.com/teonnik/sarus-amd-hook-test ${SRC_DIR} && \
    mkdir -p ${SRC_DIR}/build && \
    cd ${SRC_DIR}/build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="/opt/rocm;/opt/rocm/hip" && \
    make

ENTRYPOINT ["/bin/bash", "--rcfile", "/etc/profile", "-l", "-c"]

