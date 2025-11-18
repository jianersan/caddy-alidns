# 使用官方Caddy builder镜像构建，然后复制到精简的运行镜像
FROM caddy:2.7.6-builder-alpine AS builder

# 使用xcaddy直接构建包含alidns插件的Caddy
RUN xcaddy build \
    --with github.com/caddy-dns/alidns \
    --output /usr/bin/caddy

# 运行阶段：使用最小的运行时镜像
FROM caddy:2.7.6-alpine

# 从构建阶段复制定制化的Caddy二进制文件
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# 验证插件安装
RUN caddy list-modules | grep alidns

# 使用非root用户运行
USER caddy

# 暴露端口
EXPOSE 80 443 2019

# 启动命令
CMD ["caddy", "run"]
