# 安装 prometheus

需要注意在防火墙中设置允许9100端口给node-exporter
```
# 放开所有对9100端口的连接
iptables -I INPUT -p tcp -dport 9100 -j ACCEPT

# 放开对docker网络的连接
iptables -I INPUT -p tcp -s 172.17.0.1/24 -dport 9100 -j ACCEPT
```