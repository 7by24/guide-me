# ============================================
# 阶段一：从 pgvector 镜像提取已编译的文件
# ============================================
FROM pgvector/pgvector:pg18 AS pgvector-source

# 创建临时目录，复制 pgvector 相关文件
RUN mkdir -p /pgvector-files/lib /pgvector-files/share \
    && cp /usr/lib/postgresql/18/lib/vector.so /pgvector-files/lib/ \
    && cp /usr/share/postgresql/18/extension/vector* /pgvector-files/share/

# ============================================
# 阶段二：从 postgis 镜像提取已编译的文件（可选）
# ============================================
FROM postgis/postgis:18-3.5 AS postgis-source

RUN mkdir -p /postgis-files/lib /postgis-files/share \
    && cp /usr/lib/postgresql/18/lib/*postgis* /postgis-files/lib/ 2>/dev/null || true \
    && cp /usr/share/postgresql/18/extension/postgis* /postgis-files/share/ 2>/dev/null || true

# ============================================
# 阶段三：最终运行镜像（纯净官方镜像 + 复制扩展）
# ============================================
FROM postgres:18-bookworm

ARG BUILD_VERSION=unknown
ARG BUILD_DATE=unknown

LABEL org.opencontainers.image.version="${BUILD_VERSION}"
LABEL org.opencontainers.image.created="${BUILD_DATE}"

# 将版本写入文件，方便容器内查看
RUN echo "${BUILD_VERSION}" > /etc/postgres-version

# 安装 PostGIS 运行时依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgeos-c1v5 \
    libgdal32 \
    libproj25 \
    libprotobuf-c1 \
    libjson-c5 \
    libxml2 \
    && rm -rf /var/lib/apt/lists/*

# 复制 pgvector 文件
COPY --from=pgvector-source /pgvector-files/lib/vector.so /usr/lib/postgresql/18/lib/
COPY --from=pgvector-source /pgvector-files/share/ /usr/share/postgresql/18/extension/

# 复制 PostGIS 文件
COPY --from=postgis-source /postgis-files/lib/ /usr/lib/postgresql/18/lib/
COPY --from=postgis-source /postgis-files/share/ /usr/share/postgresql/18/extension/

# 初始化脚本：自动启用扩展
RUN mkdir -p /docker-entrypoint-initdb.d
COPY <<'EOF' /docker-entrypoint-initdb.d/10-enable-extensions.sql
CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS postgis_topology;
EOF

RUN chown postgres:postgres /docker-entrypoint-initdb.d/10-enable-extensions.sql

EXPOSE 5432
CMD ["postgres"]