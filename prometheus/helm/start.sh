#!/bin/bash
set -euo pipefail

if helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace prometheus \
  --values values.yaml \
  --wait --timeout 5m
  echo "Helm安装组件成功，继续应用路由..."
  kubectl apply -f httpRoute.yaml
  echo "部署完成"
else
    echo "Helm安装组件失败，跳过kubectl apply" >&2
    exit 1
fi