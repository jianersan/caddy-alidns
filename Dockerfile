# 第一阶段：构建阶段（使用builder标签，包含完整构建环境）
FROM caddy:2.7.6-alpine AS builder

# 安装alidns插件
RUN caddy add-package github.com/caddy-dns/alidns

# 第二阶段：运行阶段（使用纯净的运行时环境）
FROM caddy:2.7.6-alpine

# 从构建阶段复制已安装插件的Caddy二进制文件
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# 验证插件是否成功安装
RUN caddy list-modules | grep alidns

# 设置非root用户运行（安全增强）
USER caddy

# 暴露端口
EXPOSE 80 443 2019

# 使用Caddy的默认启动命令
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
