
#Requires -Version 5.1
# 证书签发脚本 (PowerShell 版本)

# 定义颜色变量
$RED = "`e[1;31m"       # 红
$GREEN = "`e[1;32m"     # 绿
$YELLOW = "`e[1;33m"    # 黄
$RES = "`e[0m"          # 清除颜色

Write-Host "=============================================="
Write-Host "=================开始证书签发================="
Write-Host "=============================================="

##################################################################################
# 创建/进入 certs 目录
if (Test-Path -Path 'certs' -PathType Container) {
    Set-Location -Path 'certs'
}
else {
    New-Item -ItemType Directory -Name 'certs' | Out-Null
    Set-Location -Path 'certs'
}

if (Test-Path -Path 'ca.crt' -PathType Leaf) {
    Write-Host "${RED}清理旧证书${RES}"
    Get-ChildItem -Path . -Force | Select-Object -ExpandProperty Name
    Start-Sleep -Seconds 1
    Remove-Item -Path * -Recurse -Force
    Write-Host "${GREEN}完成清理${RES}"
}
else {
    Write-Host "${GREEN}当前目录为空，准备生成证书${RES}"
}
Write-Host ""

##################################################################################
Write-Host "${YELLOW}生成CA私钥和证书${RES}"
Start-Sleep -Seconds 1

# 1. 生成 CA私钥
openssl genrsa -out ca.key 4096

# 2. 生成 CA证书
openssl req -new -x509 -sha256 -nodes -days 3650 -key ca.key -out ca.crt `
    -subj "/C=countryCode/ST=province/L=city/O=og/OU=department/CN=commonName"

Write-Host "${GREEN}$(Get-ChildItem -Name)${RES}"
Write-Host ""

##################################################################################
Write-Host "${RED}服务器端:${RES}"
Write-Host "${YELLOW}生成私钥${RES}"
Start-Sleep -Seconds 1

# 3. 服务器私钥
New-Item -ItemType Directory -Name 'server' | Out-Null
Set-Location -Path 'server'
openssl genrsa -out server.key 4096

Write-Host "${GREEN}$(Get-ChildItem -Name)${RES}"
Write-Host "${YELLOW}签发证书${RES}"
Start-Sleep -Seconds 1

# 4. 生成服务器证书请求
openssl req -new -sha256 -key server.key -out server.csr `
    -subj "/C=countryCode/ST=province/L=city/O=og/OU=department/CN=commonName"

# 5. 使用 CA签发服务器证书
openssl x509 -req -in server.csr -CA ../ca.crt -CAkey ../ca.key `
    -CAcreateserial -out server.crt -days 365 -sha256

Copy-Item -Path '../ca.crt' -Destination '.'
Write-Host "${GREEN}$(Get-ChildItem -Name)${RES}"
Set-Location -Path '..'
Write-Host ""

##################################################################################
Write-Host "${RED}客户端:${RES}"
Write-Host "${YELLOW}生成私钥${RES}"
Start-Sleep -Seconds 1

New-Item -ItemType Directory -Name 'client' | Out-Null
Set-Location -Path 'client'

# 6. 客户端私钥
openssl genrsa -out client.key 4096

Write-Host "${GREEN}$(Get-ChildItem -Name)${RES}"
Write-Host "${YELLOW}签发证书${RES}"
Start-Sleep -Seconds 1

# 7. 生成客户端证书请求
openssl req -new -sha256 -key client.key -out client.csr `
    -subj "/C=countryCode/ST=province/L=city/O=og/OU=department/CN=commonName"

# 8. 使用 CA签发客户端证书
openssl x509 -req -in client.csr -CA ../ca.crt -CAkey ../ca.key `
    -CAcreateserial -out client.crt -days 365 -sha256

Copy-Item -Path '../ca.crt' -Destination '.'
Write-Host "${GREEN}$(Get-ChildItem -Name)${RES}"
Set-Location -Path '..'

Remove-Item -Path 'ca.*' -Force

##################################################################################
Write-Host "==================证书签发完成=================="
Write-Host ""
