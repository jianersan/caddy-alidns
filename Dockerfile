# 编译阶段
FROM caddy:2.7-builder AS builder

ENV GOPROXY=https://goproxy.cn,direct
# 1. 手动拉取稳定版源码  2. 本地插插件编译
RUN git clone --depth 1 --branch v2.7.3 \
      https://github.com/caddyserver/caddy.git /src/caddy && \
    cd /src/caddy && \
    xcaddy build \
      --with github.com/caddy-dns/alidns

# 运行阶段
FROM caddy:2.7-alpine
COPY --from=builder /src/caddy/caddy /usr/bin/caddy
EXPOSE 80 443 2019
ENTRYPOINT ["caddy"]
