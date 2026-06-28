```
# 在powershell中执行
# 安装 openssl
winget install --id ShiningLight.OpenSSL.Dev --source winget
# 先临时修改安全策略
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
# 然后
./signCA.ps1
```