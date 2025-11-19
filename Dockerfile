FROM caddy:2.10.2-alpine-builder AS builder

RUN xcaddy build \
    --with github.com/caddy-dns/alidns

FROM caddy:2.10.2-alpine

COPY --from=builder /usr/bin/caddy /bin/caddy
