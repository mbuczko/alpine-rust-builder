FROM alpine:latest
ARG S6_OVERLAY_VERSION=3.1.4.2

RUN apk add curl git autoconf automake g++ libtool make openssl-dev pkgconf protoc
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rustup.sh && sh ./rustup.sh -y --default-toolchain nightly
ENV PATH "/root/.cargo/bin:${PATH}"

# Recompile the newest version of ZMQ
RUN mkdir libs && cd libs && \
    curl -LO https://github.com/zeromq/libzmq/releases/download/v4.3.4/zeromq-4.3.4.tar.gz && \
    tar xzf zeromq-4.3.4.tar.gz && cd zeromq-4.3.4 && \
    ./autogen.sh && \
    ./configure --disable-dependency-tracking --without-docs && \
    make && make install && cd .. && rm zeromq-4.3.4.tar.gz && rm -rf zeromq-4.3.4

# Download the static build of Litestream directly into the path & make it executable.
# This is done in the builder and copied as the chmod doubles the size.
ADD https://github.com/benbjohnson/litestream/releases/download/v0.3.9/litestream-v0.3.9-linux-amd64-static.tar.gz /tmp/litestream.tar.gz
ADD https://github.com/benbjohnson/litestream/releases/download/v0.3.9/litestream-v0.3.9-linux-amd64-static.tar.gz /tmp/litestream.tar.gz
RUN tar -C /tmp -xzf /tmp/litestream.tar.gz

# Download the s6-overlay for process supervision.
# This is done in the builder to reduce the final build size.
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
