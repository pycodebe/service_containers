FROM node:20.9.0-bullseye AS Builder

ENV CRONICLE_VERSION=0.9.38

WORKDIR /opt/cronicle

COPY Cronicle-${CRONICLE_VERSION}.tar.gz /tmp/

RUN tar zxvf /tmp/Cronicle-${CRONICLE_VERSION}.tar.gz -C /tmp/ && \
    mv /tmp/Cronicle-${CRONICLE_VERSION}/* . && \
    rm -rf /tmp/* && \
    npm install

COPY ./patches /tmp/patches
RUN patch -p3 < /tmp/patches/engine.patch lib/engine.js
COPY entrypoint.js ./bin/

# ------------------------------------------------------------------

FROM node:20.9.0-alpine

RUN apk add procps curl nano bash gawk tar iproute2 iputils-ping openssh-client

COPY --from=builder /opt/cronicle/ /opt/cronicle/

WORKDIR /opt/cronicle

RUN node bin/build.js dist && bin/control.sh setup
