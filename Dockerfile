# 使用更轻量的ARM64基础镜像，减少依赖问题
FROM arm64v8/alpine:3.18

# 安装构建依赖（Alpine使用apk包管理器）
RUN apk add --no-cache \
    ca-certificates \
    git \
    go \
    gcc \
    musl-dev

# 设置Go环境变量
ENV GOPATH=/go
ENV PATH=$PATH:/go/bin

# 安装 xcaddy
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

# 使用 xcaddy 构建包含阿里云DNS插件的Caddy
RUN xcaddy build \
    --with github.com/caddy-dns/alidns@latest \
    --output /usr/bin/caddy

# 验证构建是否成功
RUN /usr/bin/caddy version
