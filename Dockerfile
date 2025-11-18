# 使用已验证稳定的基础镜像
FROM caddy:2.7.6-alpine

# 使用Caddy内置命令安装插件（此方法之前已验证成功）
RUN caddy add-package github.com/caddy-dns/alidns

# 安装后清理APT缓存，减少镜像体积
RUN rm -rf /var/cache/apk/*

# 验证插件是否安装成功
RUN caddy list-modules | grep alidns

# 使用非root用户运行（安全最佳实践）
USER caddy

# 暴露Caddy默认端口
EXPOSE 80 443 2019

# 使用Caddy默认启动命令
CMD ["caddy", "run"]
