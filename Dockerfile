FROM caddy:2.10.2-builder-alpine AS builder

RUN xcaddy build \
      --with github.com/caddy-dns/alidns

FROM alpine:3.20
RUN apk add --no-cache ca-certificates

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

VOLUME ["/data"]
EXPOSE 80 443 2019
ENTRYPOINT ["caddy"]
CMD ["run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
