# 使用一个轻量级的基础镜像
FROM alpine:latest

# 设置工作目录
WORKDIR /app
VOLUME ["/app/data", "/app/config"]

# 通过构建参数选择架构
ARG ARCH=amd64
#COPY build/linux-${ARCH}/simple-one-api /app/simple-one-api
COPY bin/simple-one-api /app/simple-one-api

# 暴露应用运行的端口（假设为9090）
EXPOSE 9090

# 运行可执行文件
CMD ["./simple-one-api", "/app/config/config.json"]
