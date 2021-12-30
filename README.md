# What it is?
It's a Rust apps builder based on Alpine (edge) container. This guarantees as small output container as possible for today.

# What's inside
Standart build chain (autoconf, automake, libtool, ...) recompiled [ZeroMQ](zeromq.org) and [Litestream](https://litestream.io/)

## Zero... what?
ZeroMQ is an awesome networking library that takes care of sending and receiving atomic messages across most popular N-N connection patterns like fan-out, publish/subscribe, request-reply, etc.

## Litestream...?
Litestream is another fantastic piece of code I use for most of my projects. Allows to replicate (realtime!) SQLite database to S3 and restore it when requested. I can't recommed it enough!
