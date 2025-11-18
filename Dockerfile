# 使用ARM64的Alpine镜像
FROM arm64v8/alpine:3.18

# 安装完整的构建工具链
RUN apk add --no-cache \
    ca-certificates \
    git \
    go \
    gcc \
    musl-dev \
    build-base

# 创建Go工作目录并设置权限
RUN mkdir -p /go/bin && chmod -R 777 /go

# 设置Go环境变量
ENV GOPATH=/go
ENV GOBIN=/go/bin
ENV PATH=$PATH:/go/bin
ENV GO111MODULE=on
ENV GOPROXY=https://goproxy.cn,direct

# 工作目录
WORKDIR /build

# 安装xcaddy
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

# 验证xcaddy安装
RUN ls -la /go/bin/ && /go/bin/xcaddy version

# 构建Caddy with alidns插件
RUN /go/bin/xcaddy build \
    --with github.com/caddy-dns/alidns@latest \
    --output /usr/bin/caddy

# 验证caddy安装
RUN /usr/bin/caddy version

# 清理不必要的构建依赖
RUN apk del --purge build-base gcc musl-dev git

# 设置启动命令
CMD ["caddy", "run"]
