# 第一阶段：构建
FROM caddy:2.10.2-builder-alpine AS builder
RUN caddy add-package github.com/caddy-dns/alidns
# 第二阶段：运行
FROM caddy:2.10.2-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
