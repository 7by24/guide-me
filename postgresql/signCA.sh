#!/bin/bash
set -e
 #定义颜色变量
RED='\E[1;31m'      # 红
GREEN='\E[1;32m'    # 绿
YELLOW='\E[1;33m'   # 黄
RES='\E[0m'         # 清除颜色

echo -e "=============================================="
echo -e "=================开始证书签发================="
echo -e "=============================================="
##################################################################################
if [ -d 'certs' ]; then
  cd certs
  else
  mkdir certs && cd certs
fi
if [ -f 'ca.crt' ]; then
  echo -e "${RED}清理旧证书${RES}"
  ls -Ahv
  sleep 1
  rm -rf *
  echo -e "${GREEN}完成清理${RES}"
  else
  echo -e "${GREEN}当前目录为空，准备生成证书${RES}"
fi
echo ""
##################################################################################
echo -e "${YELLOW}生成CA私钥和证书${RES}"
sleep 1
# 1. 生成 CA私钥
openssl genrsa -out ca.key 4096
# 2. 生成 CA证书
openssl req -new -x509 -sha256 -nodes -days 3650 -key ca.key -out ca.crt \
  -subj "/C=CN/ST=Sichuan/L=Chengdu/O=oyea/OU=IT/CN=supdbo"
echo -e "${GREEN}$(ls -A)${RES}"
echo ""
##################################################################################
echo -e "${RED}服务器端:${RES}"
echo -e "${YELLOW}生成私钥${RES}"
sleep 1
# 3. 服务器私钥
mkdir server && cd server
openssl genrsa -out server.key 4096
echo -e "${GREEN}$(ls -A)${RES}"
echo -e "${YELLOW}签发证书${RES}"
sleep 1
# 4. 生成服务器证书请求
openssl req -new -sha256 -key server.key -out server.csr \
  -subj "/C=CN/ST=Sichuan/L=Chengdu/O=oyea/OU=IT/CN=supdbo"
# 5. 使用 CA签发服务器证书
openssl x509 -req -in server.csr -CA ../ca.crt -CAkey ../ca.key \
  -CAcreateserial -out server.crt -days 365 -sha256

cp ../ca.crt .
echo -e "${GREEN}$(ls -A)${RES}"
cd ..
echo ""
##################################################################################
echo -e "${RED}客户端:${RES}"
echo -e "${YELLOW}生成私钥${RES}"
sleep 1
mkdir client && cd client
# 6. 客户端私钥
openssl genrsa -out client.key 4096
echo -e "${GREEN}$(ls -A)${RES}"
echo -e "${YELLOW}签发证书${RES}"
sleep 1
# 7. 生成客户端证书请求
openssl req -new -sha256 -key client.key -out client.csr \
  -subj "/C=CN/ST=Sichuan/L=Chengdu/O=oyea/OU=IT/CN=supdbo"
# 8. 使用 CA签发客户端证书
openssl x509 -req -in client.csr -CA ../ca.crt -CAkey ../ca.key \
  -CAcreateserial -out client.crt -days 365 -sha256
cp ../ca.crt .
echo -e "${GREEN}$(ls -A)${RES}"
cd ..
rm -f ca.*
##################################################################################
echo -e "==================证书签发完成=================="
echo ""
exit 0

# 服务器端需要对postres的用户权限进行设置，允许使用证书认证登录
# docker
# sudo chown 999:999 server.key
# sudo chmod 600 server.key
# sudo chmod 644 server.crt ca.crt
# echo -e "${GREEN}$(ls -lhv)${RES}"


# 客户端证书在实际运行用户的home目录下
# 在当前设置中即在 git的home目录下的.postgresql目录下
# mkdir -p ~/.postgresql
# cp client.crt ~/.postgresql/postgresql.crt
# cp client.key ~/.postgresql/postgresql.key
# cp ca.crt ~/.postgresql/root.crt
# chmod 600 ~/.postgresql/postgresql.key
# chmod 644 ~/.postgresql/postgresql.crt ~/.postgresql/root.crt