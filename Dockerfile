FROM caddy:2.10.2-builder-alpine AS builder
RUN xcaddy build --with github.com/caddy-dns/alidns

FROM caddy:2.10.2-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
RUN rm -rf /var/cache/apk/* /tmp/*

CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
