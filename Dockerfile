
FROM alpine:latest

LABEL maintainer="Izumiko <yosoro@outlook.com>"

ARG TARGETOS=linux
ARG TARGETARCH=amd64
ARG TARGETVARIANT=""
ARG MIHOMO_VERSION=v1.19.10

ENV MIHOMO_CONFIG_DIRECTORY=/root/.config/mihomo

EXPOSE 7890 9090

# 安装基础依赖和 Python 环境 + requests 模块
RUN apk add --no-cache \
    ca-certificates \
    python3 \
    py3-pip \
    py3-yaml \
    py3-flask \
    py3-requests \
    bash \
    wget \
    && rm -rf /var/cache/apk/*

# 下载 Mihomo
RUN if [ "${TARGETARCH}" = "amd64" ]; \
then wget -qO mihomo.gz https://github.com/MetaCubeX/mihomo/releases/download/${MIHOMO_VERSION}/mihomo-${TARGETOS}-amd64-compatible-${MIHOMO_VERSION}.gz \
    && gzip -d mihomo.gz && chmod +x mihomo \
    && mv mihomo /usr/local/bin/mihomo; \
else wget -qO mihomo.gz https://github.com/MetaCubeX/mihomo/releases/download/${MIHOMO_VERSION}/mihomo-${TARGETOS}-${TARGETARCH}${TARGETVARIANT}-${MIHOMO_VERSION}.gz \
    && gzip -d mihomo.gz && chmod +x mihomo \
    && mv mihomo /usr/local/bin/mihomo; \
fi

# 启动 mihomo，可手动后台启动 Flask
ENTRYPOINT ["/usr/local/bin/mihomo", "-d", "/root/.config/mihomo"]
