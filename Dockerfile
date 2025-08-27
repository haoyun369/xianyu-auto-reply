FROM python:3.11-slim-bookworm

LABEL maintainer="zhinianboke"
LABEL version="2.2.0"
LABEL description="闲鱼自动回复系统 - ARMv7 Pyppeteer 版本"

WORKDIR /app

ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV TZ=Asia/Shanghai
ENV DOCKER_ENV=true

# 安装系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    tzdata \
    nodejs \
    npm \
    git \
    build-essential \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    fonts-dejavu-core \
    fonts-liberation \
    wget \
    unzip \
    xvfb \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN node --version && npm --version
ENV NODE_PATH=/usr/lib/node_modules

# 安装 Python 依赖
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple && \
    pip install --no-cache-dir -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# 复制项目文件
COPY . .

# 创建目录并设置权限
RUN mkdir -p /app/logs /app/data /app/backups /app/static/uploads/images \
    && chmod 777 /app/logs /app/data /app/backups /app/static/uploads /app/static/uploads/images

EXPOSE 8080

# 健康检查
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# 复制启动脚本并设置权限
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh && \
    apt-get install -y dos2unix && dos2unix /app/entrypoint.sh 2>/dev/null || true

ENTRYPOINT ["/bin/bash", "/app/entrypoint.sh"]
