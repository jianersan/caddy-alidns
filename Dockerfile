# 阶段 1：官方 builder 镜像里只编译插件
FROM caddy:2.7-builder AS builder

ENV GOPROXY=https://goproxy.cn,direct
# 利用官方预置的源码，直接插插件
RUN xcaddy build \
      --with github.com/caddy-dns/alidns

# 阶段 2：运行
FROM caddy:2.7-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
EXPOSE 80 443 2019
ENTRYPOINT ["caddy"]
