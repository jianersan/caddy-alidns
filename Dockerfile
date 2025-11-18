# 使用针对ARM64架构优化的基础镜像
FROM arm64v8/ubuntu:22.04

# 安装构建Caddy所需的依赖
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    git \
    golang-go \
    && rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /app

# 安装 xcaddy (Caddy的定制化构建工具)
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

# 使用 xcaddy 构建包含阿里云DNS插件的Caddy
RUN /root/go/bin/xcaddy build \
    --with github.com/caddy-dns/alidns@latest \
    --output /usr/bin/caddy

# 验证Caddy是否构建成功
RUN caddy version
