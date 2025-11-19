FROM caddy:2.10.2-alpine
RUN caddy add-package github.com/caddy-dns/alidns
