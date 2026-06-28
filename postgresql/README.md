# 注意事项
```
# nfs-server 配置参考
# /etc/exports: the access control list for filesystems which may be exported
#               to NFS clients.  See exports(5).
#
# Example for NFSv2 and NFSv3:
# /srv/homes       hostname1(rw,sync,no_subtree_check) hostname2(ro,sync,no_subtree_check)
#
# Example for NFSv4:
# /srv/nfs4        gss/krb5i(rw,sync,fsid=0,crossmnt,no_subtree_check)
# /srv/nfs4/homes  gss/krb5i(rw,sync,no_subtree_check)
#
/nfs/pv-pgadmin  10.0.0.0/24(rw,sync,no_subtree_check,all_squash,anonuid=5050,anongid=5050)
/nfs/pv-postgres 10.0.0.0/24(rw,sync,no_subtree_check,all_squash,anonuid=999,anongid=999)
/nfs/pv-homer 10.0.0.0/24(ro,sync,no_subtree_check,all_squash,anonuid=1000,anongid=1000)
```

```
# 部署完以后在宿主机上创建一个数据库试试
kubectl exec -it postgres-statefulset-0 -n postgres -- createdb -U username username_example_database
```
```
# 列出所有该用户下的数据库，看看创建成功没有
kubectl exec -it postgres-statefulset-0 -n postgres -- psql -U username -d default -c '\l'
```

```
# 服务器端需要对postres的用户权限进行设置，允许使用证书认证登录
# docker
# sudo chown 999:999 server.key
# sudo chmod 600 server.key
# sudo chmod 644 server.crt ca.crt
# echo -e "${GREEN}$(ls -lhv)${RES}"

```