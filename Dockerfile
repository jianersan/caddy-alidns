# 使用官方Caddy镜像作为基础
FROM caddy:2.7.6-alpine

# 安装xcaddy来构建包含alidns插件的Caddy
RUN caddy add-package github.com/caddy-dns/alidns

# 验证插件是否安装成功
RUN caddy list-modules
