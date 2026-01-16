FROM caddy:2.10.2-builder-alpine AS builder
RUN xcaddy build \
    --with github.com/caddy-dns/alidns \
    --with github.com/p_m_j/caddy-maxmind-geolocation \
    --with github.com/greenpau/caddy-security
FROM caddy:2.10.2-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
RUN mkdir -p /data/geoip
