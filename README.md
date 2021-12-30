# What it is?
It's a Rust apps builder based on Alpine (edge) container. This guarantees as small output container as possible for today.

# What's inside
Standart build chain (autoconf, automake, libtool, ...) recompiled [ZeroMQ](zeromq.org) and [Litestream](https://litestream.io/)

## Zero... what?
ZeroMQ is an awesome networking library that takes care of sending and receiving atomic messages across most popular N-N connection patterns like fan-out, publish/subscribe, request-reply, etc.

## Litestream...?
Litestream is another fantastic piece of code I use for most of my projects. Allows to replicate (realtime!) SQLite database to S3 and restore it when requested. I can't recommed it enough!

# How to use it?

For example this way:

``` dockerfile
FROM mbuczko/alpine-rust-builder:latest as builder

ADD . ./
RUN cargo install --root /tmp/foo --path .

FROM alpine:edge

# Copy executable & Litestream from builder.
COPY --from=builder /tmp/foo/bin/foo /usr/local/bin/foo
COPY --from=builder /tmp/litestream /usr/local/bin/litestream

# Install s6 for process supervision.
COPY --from=builder /tmp/s6-overlay-amd64-installer /tmp/s6-overlay-amd64-installer
RUN /tmp/s6-overlay-amd64-installer /

# Copy s6 init & service definitions.
COPY etc/cont-init.d /etc/cont-init.d
COPY etc/services.d /etc/services.d

# Copy Litestream configuration file.
COPY etc/litestream.yml /etc/litestream.yml

# The kill grace time is set to zero because our app handles shutdown through SIGTERM.
ENV S6_KILL_GRACETIME=0

# Sync disks is enabled so that data is properly flushed.
ENV S6_SYNC_DISKS=1
EXPOSE 8001

# Run the s6 init process on entry.
ENTRYPOINT [ "/init" ]
```
