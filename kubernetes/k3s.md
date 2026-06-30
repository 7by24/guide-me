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

### 在复杂网络中使用flannel xvlan的问题
- 保证内网宿主机的IP:端口在协议层面的相互可访问
- 可尝试在安装时加入对iface的使用声明，避免不同pods在不同node上无法通信。

**安装时：**
```
# server
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server \
  --flannel-iface=enp0s6 \
  --node-ip=10.0.0.xx \
  --advertise-address=10.0.0.xx \

# agent
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="agent \
  --flannel-iface=ens3 \
  --node-ip=10.0.0.xx" \
  K3S_URL=https://10.0.0.xx:6443 \
  K3S_TOKEN=<server-token> sh -
```

**已安装：**
```
# server
sudo nano /etc/systemd/system/k3s.service
ExecStart=/usr/local/bin/k3s \
    server \
        '--disable' \
        'traefik' \
        '--write-kubeconfig-mode=644' \
        '--flannel-iface=enp0s6' \
        '--node-ip=10.0.0.xxx' \
        '--advertise-address=10.0.0.xxx'

# agent
sudo nano /etc/systemd/system/k3s-agent.service
ExecStart=/usr/local/bin/k3s \
    agent \
    --flannel-iface=ens3 \
    --node-ip=10.0.0.xx \

sudo systemctl daemon-reload
sudo systemctl restart k3s/k3s-agent
```
```
# 可使用busybox进行Pod连通性测试
kubectl run test --rm --it --image=buysbox --restart=Never -- /bin/sh/ping -c 2 pod-ip
```