
FROM alpine:latest

LABEL maintainer="z1050"

ARG TARGETOS=linux
ARG TARGETARCH
ARG TARGETVARIANT
ARG MIHOMO_VERSION=v1.19.10

ENV MIHOMO_CONFIG_DIRECTORY=/root/.config/mihomo

EXPOSE 7890 9090

# 安装基础依赖和 Python 模块
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

# 下载 mihomo 可执行文件，根据不同架构选择不同链接
RUN set -e; \
    case "${TARGETARCH}" in \
        amd64)   FILE="mihomo-linux-amd64-${MIHOMO_VERSION}.gz" ;; \
        arm64)   FILE="mihomo-linux-arm64-${MIHOMO_VERSION}.gz" ;; \
        arm)     FILE="mihomo-linux-armv7-${MIHOMO_VERSION}.gz" ;; \
        *)       echo "Unsupported architecture: ${TARGETARCH}"; exit 1 ;; \
    esac; \
    URL="https://github.com/MetaCubeX/mihomo/releases/download/${MIHOMO_VERSION}/${FILE}"; \
    echo "Downloading $URL"; \
    wget -O mihomo.gz "$URL" && gzip -d mihomo.gz && chmod +x mihomo && mv mihomo /usr/local/bin/mihomo

# 默认启动命令

ENTRYPOINT ["/bin/sh", "-c", "/usr/local/bin/mihomo -d /root/.config/mihomo & python3 /root/.config/mihomo/mihomo-new.py"]
