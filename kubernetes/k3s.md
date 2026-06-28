# 安装向导

### 安装 k3s
> 禁用traefik ingress，使用nginx-gateway-fabric替代
- Server 节点
```
curl -sfL https://get.k3s.io | sh -s - --disable traefik --write-kubeconfig-mode=644
```
```
# in China
curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn sh -s - --disable traefik --write-kubeconfig-mode=644
```

- Agent 节点
```
# token存储在server节点的/var/lib/rancher/k3s/server/node-token文件中
curl -sfL https://get.k3s.io | K3S_URL=https://myserver:6443 K3S_TOKEN=mynodetoken sh -
```
```
# in China
curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn K3S_URL=https://myserver:6443 K3S_TOKEN=mynodetoken sh -
```

### 安装 helm
```
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-4 | bash
```



### 卸载 k3s
```
# server
/usr/local/bin/k3s-uninstall.sh

# agent
/usr/local/bin/k3s-agent-uninstall.sh
```

### 卸载 helm
```
rm -r /usr/local/bin/helm
rm -r ~/.cache/helm
rm -r ~/.config/helm
```

