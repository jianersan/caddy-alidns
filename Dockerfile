# 编译阶段
FROM caddy:2.8-builder AS builder
RUN xcaddy build --with github.com/caddy-dns/alidns

# 运行阶段
FROM caddy:2.8-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
EXPOSE 80 443 2019
ENTRYPOINT ["caddy"]
