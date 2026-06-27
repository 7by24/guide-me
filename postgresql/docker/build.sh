#!/bin/bash

# 每次构建前自动更新 .env
echo "BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')" > .env && echo "BUILD_VERSION=1.0.1" > .env && docker-compose build