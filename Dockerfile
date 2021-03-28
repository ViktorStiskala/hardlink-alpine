ARG BASE_IMAGE=alpine:latest

FROM ${BASE_IMAGE} AS builder

# build requirements
RUN apk add --no-cache --upgrade \
    gcc \
    make \
    musl-dev \
    pcre-dev

ADD hardlink_0.3.0.tar.xz /src/

WORKDIR /src/hardlink-0.3.0

# replace include path in source file to adapt for Alpine Linux
RUN sed -i 's/#include <attr\/xattr.h>/#include <sys\/xattr.h>/g' hardlink.c \
    && make -j \
    && make install

FROM ${BASE_IMAGE}

# runtime requirements
RUN apk add --no-cache --upgrade pcre

COPY --from=builder /usr/bin/hardlink /usr/bin/hardlink
