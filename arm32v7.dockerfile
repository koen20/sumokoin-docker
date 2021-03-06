FROM alpine AS builder

# Download QEMU, see https://github.com/docker/hub-feedback/issues/1261
ENV QEMU_URL https://github.com/balena-io/qemu/releases/download/v4.0.0%2Bbalena2/qemu-4.0.0.balena2-arm.tar.gz
RUN apk add curl && curl -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1

FROM debian@sha256:030ab272b197c7e534d4807c14842d751280fc8eec87aa00ae102abf19888e85

COPY --from=builder qemu-arm-static /usr/bin

RUN mkdir /data && mkdir /data/bin && mkdir /data/config
WORKDIR /data/bin
RUN apt-get update && apt-get install wget xz-utils -y && wget https://github.com/sumoprojects/sumokoin/releases/download/v0.8.0.0/sumokoin.linux.armv7.v0-8-0-0.tar.xz -O sumokoin.tar.xz && tar -xf "sumokoin.tar.xz" && rm sumokoin.tar.xz && apt-get remove wget xz-utils -y && apt-get clean && cp sumokoin.linux.armv7.v0-8-0-0/sumo-wallet-rpc /data/bin && rm -R sumokoin.linux.armv7.v0-8-0-0

WORKDIR /data/config
