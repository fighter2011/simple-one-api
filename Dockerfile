FROM golang:1.22-alpine as builder

ENV GOPROXY="https://goproxy.cn,direct"
ARG VERSION
WORKDIR /app/

COPY go.mod .
COPY go.sum .
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -ldflags "-s -w" -o ./bin/simple-one-api

FROM alpine:latest
LABEL MAINTAINER="nibuchiwochile@gmail.com"
WORKDIR /app/
VOLUME ["/app/data/", "/app/config/", "/app/logs/"]

RUN apk add ca-certificates tzdata \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/shanghai" >> /etc/timezone \
    && apk del tzdata

# 将builder构建生成的产物复制到这儿
COPY --from=builder /app/bin/simple-one-api /app/simple-one-api

EXPOSE 9090
CMD ["./simple-one-api", "/app/config/config.json"]

# 在项目根目录执行命令如下 上面COPY是相对于docker执行上下文 即当前执行目录
# docker build -f ./docker/Dockerfile -t wxassistant:1.0 .