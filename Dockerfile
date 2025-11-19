# ---------- 编译阶段 ----------
FROM alpine:3.22 AS builder

# 1. 一次性构建依赖
RUN apk add --no-cache go git make gcc musl-dev

# 2. 拉取 xcaddy 源码
WORKDIR /tmp
RUN git clone --depth 1 https://github.com/caddyserver/xcaddy.git

# 3. 先编译出 xcaddy 可执行文件
WORKDIR /tmp/xcaddy/cmd/xcaddy
RUN go build -o xcaddy .

# 4. 用 xcaddy 编译最新 Caddy + 仅 alidns 插件
ENV GOTOOLCHAIN=auto
RUN ./xcaddy build latest --with github.com/caddy-dns/alidns

# 5. 验证插件
RUN ./caddy list-modules | grep alidns

# ---------- 运行阶段 ----------
FROM alpine:3.22

# 6. 复制单文件二进制（路径短）
COPY --from=builder /tmp/xcaddy/cmd/xcaddy/caddy /usr/local/bin/caddy

# 7. 最小运行时
RUN apk add --no-cache tzdata ca-certificates && \
    update-ca-certificates && \
    rm -rf /var/cache/apk/*

# 8. 用户降权
RUN adduser -D -u 1000 caddy && \
    mkdir -p /etc/caddy /data && \
    chown -R caddy:caddy /etc/caddy /data

USER caddy
WORKDIR /data
EXPOSE 80 443

ENTRYPOINT ["/usr/local/bin/caddy"]
CMD ["run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
