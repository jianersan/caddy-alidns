# 编译阶段
FROM caddy:2.7-builder AS builder

# 国内代理 + 固定 2.7.3 标签
RUN go env -w GOPROXY=https://goproxy.cn,direct \
 && xcaddy build v2.7.3 \
      --with github.com/caddy-dns/alidns

# 运行阶段
FROM caddy:2.7-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
EXPOSE 80 443 2019
ENTRYPOINT ["caddy"]
