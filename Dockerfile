FROM alpine:edge

RUN apk add rust cargo openssl-dev curl autoconf automake libtool g++ make pkgconf

# Recompile the newest version of ZMQ
RUN mkdir libs && cd libs && \
    curl -LO https://github.com/zeromq/libzmq/releases/download/v4.3.4/zeromq-4.3.4.tar.gz && \
    tar xzf zeromq-4.3.4.tar.gz && cd zeromq-4.3.4 && \
    ./autogen.sh && \
    ./configure --disable-dependency-tracking --without-docs && \
    make && make install

# Download the static build of Litestream directly into the path & make it executable.
# This is done in the builder and copied as the chmod doubles the size.
ADD https://github.com/benbjohnson/litestream/releases/download/v0.3.7/litestream-v0.3.7-linux-amd64-static.tar.gz /tmp/litestream.tar.gz
RUN tar -C /tmp -xzf /tmp/litestream.tar.gz

# Download the s6-overlay for process supervision.
# This is done in the builder to reduce the final build size.
ADD https://github.com/just-containers/s6-overlay/releases/download/v2.2.0.3/s6-overlay-amd64-installer /tmp/
RUN chmod +x /tmp/s6-overlay-amd64-installer
