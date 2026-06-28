```
# 客户端证书在实际运行用户的home目录下
# 在当前设置中即在 git的home目录下的.postgresql目录下
# mkdir -p ~/.postgresql
# cp client.crt ~/.postgresql/postgresql.crt
# cp client.key ~/.postgresql/postgresql.key
# cp ca.crt ~/.postgresql/root.crt
# chmod 600 ~/.postgresql/postgresql.key
# chmod 644 ~/.postgresql/postgresql.crt ~/.postgresql/root.crt
```