#!/bin/bash
set -euo pipefail
if helm uninstall prometheus -n prometheus
   echo "Helm停止组件成功，继续停止http route"
   kubectl delete -f httpRoute.yaml
   echo "全部停止"
else
    echo "停止失败"
    exit 1
fi