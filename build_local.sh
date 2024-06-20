#!/bin/bash

## 获取用户输入的平台和架构，默认为当前系统平台和架构
#
## 设置二进制文件的输出名称
#BINARY_NAME="simple-one-api"
#
## 编译项目
#echo "Building"
#CGO_ENABLED=0 GOOS=linux GOARCH=amd64  go build -o ./bin/$BINARY_NAME
#
#echo "Build completed. Copying the executable to the project root directory..."
#
## 返回到原始目录
#cd - > /dev/null
#
#echo "Build and copy completed successfully!"
#
#docker build -t fighter2011/simple-one-api:2.0 .

# 检查是否提供了版本号参数
if [ -z "$1" ]; then
    echo "Usage: $0 <version>"
    exit 1
fi

docker build -t fighter2011/simple-one-api:$1 .