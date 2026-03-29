FROM debian:bookworm-slim AS builder

ARG DEBIAN_FRONTEND=noninteractive
ARG MTPROXY_REPO=https://github.com/TelegramMessenger/MTProxy
ARG MTPROXY_REF=master

WORKDIR /src

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    make \
    gcc \
    g++ \
    libc6-dev \
    zlib1g-dev \
    libssl-dev \
 && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 --branch "${MTPROXY_REF}" "${MTPROXY_REPO}" /src/MTProxy

WORKDIR /src/MTProxy

RUN make

FROM debian:bookworm-slim

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    libssl3 \
    zlib1g \
    curl \
    wget \
    net-tools \
    procps \
 && rm -rf /var/lib/apt/lists/*

COPY --from=builder /src/MTProxy/objs/bin/mtproto-proxy /mtproto-proxy
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /mtproto-proxy /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
