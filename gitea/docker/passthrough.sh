# 创建 git用户
sudo adduser --system --disabled-login --disabled-password --home /home/git git
id git
sudo -u git ssh-keygen -t rsa -b 4096 -C "Gitea Host Key"
echo "$(cat /home/git/.ssh/id_rsa.pub)" >> /home/git/.ssh/authorized_keys
sudo chown -R git:git /home/git/.ssh
sudo chmod 700 /home/git/.ssh
sudo chmod 600 /home/git/.ssh/authorized_keys


# 创建ssh转发脚本
sudo vi /usr/local/bin/gitea
ssh -p 222 -o StrictHostKeyChecking=no git@127.0.0.1 "SSH_ORIGINAL_COMMAND=\"$SSH_ORIGINAL_COMMAND\" $0 $@"
sudo chmod +x /usr/local/bin/gitea

# docker映射相关目录并启动

# 测试
ssh -T git@ip -p 222