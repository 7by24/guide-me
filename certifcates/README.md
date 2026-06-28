```
# 在powershell中执行
# 安装 openssl
https://slproweb.com/products/Win32OpenSSL.html
winget install --id ShiningLight.OpenSSL.Light --source winget
# 先临时修改安全策略
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
# 然后
./signCA.ps1
```