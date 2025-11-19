FROM alpine:3.22 AS builder

RUN apk add --no-cache go git
WORKDIR /data
RUN git clone --depth=1 https://github.com/caddyserver/xcaddy.git
WORKDIR /data/xcaddy/cmd/xcaddy
RUN go build -o xcaddy . && \
    ./xcaddy build latest --with github.com/caddy-dns/alidns
RUN /data/xcaddy/cmd/xcaddy/caddy list-modules | grep alidns

FROM alpine:3.22
COPY --from=builder /data/xcaddy/cmd/xcaddy/caddy /usr/bin/caddy
RUN apk add --no-cache tzdata ca-certificates && \
    update-ca-certificates && \
    rm -rf /var/cache/apk/*
WORKDIR /data
ENV TZ=Asia/Shanghai
RUN adduser -D -u 1000 caddy && \
    mkdir -p /etc/caddy /data && \
    chown -R caddy:caddy /etc/caddy /data
USER caddy
EXPOSE 80 443
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
