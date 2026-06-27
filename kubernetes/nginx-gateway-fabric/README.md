### 安装 nginx-gateway-fabric
> https://docs.nginx.com/nginx-gateway-fabric/install/helm/
```
# crds
kubectl kustomize "https://github.com/nginx/nginx-gateway-fabric/config/crd/gateway-api/standard?ref=v2.6.5" | kubectl apply -f -

# oci
helm install ngf oci://ghcr.io/nginx/charts/nginx-gateway-fabric --create-namespace -n nginx-gateway
```

### 卸载 nginx-gateway-fabric
```
helm uninstall ngf -n nginx-gateway
kubectl delete ns nginx-gateway

# delete crds
kubectl delete -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v2.6.5/deploy/crds.yaml

# delete gateway api resource
kubectl kustomize "https://github.com/nginx/nginx-gateway-fabric/config/crd/gateway-api/standard?ref=v2.6.5" | kubectl delete -f -
```