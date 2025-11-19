# 第一阶段：构建（使用 xcaddy 编译）
FROM caddy:2.10.2-builder-alpine AS builder
# 使用 xcaddy 构建包含 alidns 插件的 Caddy
RUN xcaddy build \
    --with github.com/caddy-dns/alidns

# 第二阶段：运行（复制编译好的二进制文件）
FROM caddy:2.10.2-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
