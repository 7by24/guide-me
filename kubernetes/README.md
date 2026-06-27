# Kubernets 参考手册

### kubernetes的核心组件及其说明
1. 控制平面组件（Control Plane Components）

| 组件                           | 作用                           | 部署方式          |
| ---------------------------- | ---------------------------- | ------------- |
| **kube-apiserver**           | API 入口，处理所有 REST 请求          | 静态 Pod / 系统服务 |
| **etcd**                     | 分布式键值存储，保存集群所有数据             | 独立集群或静态 Pod   |
| **kube-scheduler**           | 监听未调度 Pod，选择合适节点             | 静态 Pod / 系统服务 |
| **kube-controller-manager**  | 运行各类控制器（Node、Job、Endpoint 等） | 静态 Pod / 系统服务 |
| **cloud-controller-manager** | 对接云厂商 API（负载均衡、路由等）          | 可选，云环境使用      |

2. 节点组件（Node Components）

| 组件                            | 作用                       | 部署方式             |
| ----------------------------- | ------------------------ | ---------------- |
| **kubelet**                   | 接收 API 指令，管理节点上 Pod 生命周期 | 每个节点系统服务         |
| **kube-proxy**                | 维护网络规则，实现 Service 负载均衡   | DaemonSet / 系统服务 |
| **容器运行时**（containerd / CRI-O） | 拉取镜像、运行容器                | 每个节点系统服务         |

3. 核心资源（Core Resources）

- 工作负载（Workload）

| 资源              | 用途                  | 是否推荐生产使用             |
| --------------- | ------------------- | -------------------- |
| **Pod**         | 最小调度单元，包含一个或多个容器    | ✅ 基础单元               |
| **Deployment**  | 管理无状态应用，支持滚动更新和回滚   | ✅ 最常用                |
| **StatefulSet** | 管理有状态应用，保证稳定网络标识和存储 | ✅ 数据库等               |
| **DaemonSet**   | 每个节点运行一个 Pod 副本     | ✅ 日志/监控代理            |
| **ReplicaSet**  | 确保指定数量的 Pod 副本运行    | ⚠️ 通常由 Deployment 管理 |
| **Job**         | 运行一次性任务到完成          | ✅ 批处理                |
| **CronJob**     | 定时运行 Job            | ✅ 定时任务               |

- 服务与网络（Service & Network）

| 资源                | 用途                                                             |
| ----------------- | -------------------------------------------------------------- |
| **Service**       | 为一组 Pod 提供稳定访问入口（ClusterIP/NodePort/LoadBalancer/ExternalName） |
| **Ingress**       | 基于 HTTP/HTTPS 的七层路由规则                                          |
| **IngressClass**  | 定义 Ingress 控制器类型                                               |
| **NetworkPolicy** | 定义 Pod 间网络访问策略                                                 |
| **EndpointSlice** | Service 后端 Pod 地址集合（替代旧版 Endpoints）                            |
 
- 配置与存储（Config & Storage）

| 资源                              | 用途                            |
| ------------------------------- | ----------------------------- |
| **ConfigMap**                   | 存储非敏感配置数据（键值对或文件）             |
| **Secret**                      | 存储敏感数据（密码、Token、证书），Base64 编码 |
| **PersistentVolume (PV)**       | 集群级存储资源                       |
| **PersistentVolumeClaim (PVC)** | 用户申请存储的声明                     |
| **StorageClass**                | 定义动态存储供应的模板                   |

- 身份与权限（RBAC）

| 资源                     | 用途                                   |
| ---------------------- | ------------------------------------ |
| **ServiceAccount**     | 为 Pod 提供集群内身份标识                      |
| **Role**               | 命名空间级别的权限规则                          |
| **ClusterRole**        | 集群级别的权限规则                            |
| **RoleBinding**        | 将 Role 绑定到用户/组/ServiceAccount        |
| **ClusterRoleBinding** | 将 ClusterRole 绑定到用户/组/ServiceAccount |

- 调度与资源管理（Scheduling & Resource）

| 资源                            | 用途                      |
| ----------------------------- | ----------------------- |
| **Namespace**                 | 逻辑隔离资源的作用域              |
| **ResourceQuota**             | 限制命名空间的资源总量             |
| **LimitRange**                | 限制命名空间内 Pod/容器的资源默认值和范围 |
| **PriorityClass**             | 定义 Pod 调度优先级            |
| **PodDisruptionBudget (PDB)** | 保证升级/驱逐时最小可用 Pod 数量     |

- 自动扩展（Autoscaling）

| 资源                                | 用途                          |
| --------------------------------- | --------------------------- |
| **HorizontalPodAutoscaler (HPA)** | 根据 CPU/内存/自定义指标自动扩缩 Pod 副本数 |
| **VerticalPodAutoscaler (VPA)**   | 自动调整 Pod 的 CPU/内存请求和限制      |
| **ClusterAutoscaler**             | 根据负载自动增删节点（非原生资源，通常由云厂商提供）  |

- 安全与策略（Security & Policy）

| 资源                                 | 用途                        |
| ---------------------------------- | ------------------------- |
| **PodSecurityPolicy (PSP)**        | 定义 Pod 安全标准（已废弃，v1.25 移除） |
| **PodSecurityAdmission**           | 内置 Pod 安全准入控制器（替代 PSP）    |
| **ValidatingWebhookConfiguration** | 注册准入 Webhook（验证）          |
| **MutatingWebhookConfiguration**   | 注册准入 Webhook（变更）          |

- 常用扩展资源（Addons / 插件）

| 资源/组件                         | 用途                       |
| ----------------------------- | ------------------------ |
| **CoreDNS**                   | 集群 DNS 服务                |
| **kube-dns**                  | 旧版 DNS 服务（已被 CoreDNS 替代） |
| **Metrics Server**            | 聚合节点和 Pod 资源使用指标         |
| **Dashboard**                 | Kubernetes Web UI        |
| **Fluentd / Fluent Bit**      | 日志收集                     |
| **Prometheus + Grafana**      | 监控告警与可视化                 |
| **Calico / Cilium / Flannel** | CNI 网络插件                 |
| **cert-manager**              | 自动化 TLS 证书管理             |
| **ArgoCD / Flux**             | GitOps 持续交付              |

4. 资源关系

Namespace
├── ServiceAccount
├── ConfigMap / Secret
├── PersistentVolumeClaim
├── Deployment
│   └── ReplicaSet
│       └── Pod (由 kubelet + 容器运行时管理)
├── StatefulSet
│   └── Pod + PVC
├── DaemonSet
│   └── Pod (每个节点一个)
├── Job
│   └── Pod (运行到完成)
├── CronJob
│   └── Job
├── Service
│   └── EndpointSlice (指向 Pod IP)
├── Ingress
│   └── 指向 Service
├── NetworkPolicy
│   └── 作用于 Pod
├── ResourceQuota / LimitRange / PDB
└── Role + RoleBinding / ClusterRole + ClusterRoleBinding

### Homelab
| 类型 | 说明 |
|:------|:------|
| k3s | k3s 应用 |
| nginx-gateway-fabric | gateway api |
| cert-manager | 证书管理 |
| reference | 参考说明 |

### 可能感兴趣读一读
1. 推荐标签文档（Recommended Labels）
URL: https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/
文档标题为 "Recommended Labels"，明确列出了 6 个推荐标签。

| 标签键                            | 描述        | 示例                 |
| ------------------------------ | --------- | ------------------ |
| `app.kubernetes.io/name`       | 应用名称      | `mysql`            |
| `app.kubernetes.io/instance`   | 应用实例的唯一标识 | `wordpress-abcxzy` |
| `app.kubernetes.io/version`    | 应用当前版本    | `5.7.21`           |
| `app.kubernetes.io/component`  | 架构中的组件    | `database`         |
| `app.kubernetes.io/part-of`    | 所属的高级应用   | `wordpress`        |
| `app.kubernetes.io/managed-by` | 管理该应用的工具  | `helm`             |


2. 知名标签参考文档（Well-Known Labels）
URL: https://kubernetes.io/docs/reference/labels-annotations-taints/
这是 Kubernetes 官方 API 参考文档中的 "Well-Known Labels, Annotations and Taints" 章节，对每个标签提供了更详细的类型定义和使用范围说明，例如：
```
app.kubernetes.io/name
  Type: Label
  Used on: All Objects
  Description: The name of the application.
  One of the recommended labels.
```