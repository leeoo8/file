# 使用 Mintplex Labs 的 AnythingLLM 镜像作为基础镜像
FROM mintplexlabs/anythingllm

# 设置工作目录
WORKDIR /app

# 仅复制 package.json 和 package-lock.json（如果有）用于依赖安装
COPY package*.json /app/

# 安装生产环境依赖
RUN npm install --omit=dev

# 将项目文件复制到容器中
COPY . /app

# 设置环境变量
ENV STORAGE_DIR=/app/server/storage \
    JWT_SECRET="make this a large list of random numbers and letters 20+" \
    LLM_PROVIDER=ollama \
    OLLAMA_BASE_PATH=http://127.0.0.1:11434 \
    OLLAMA_MODEL_PREF=llama2 \
    OLLAMA_MODEL_TOKEN_LIMIT=4096 \
    EMBEDDING_ENGINE=ollama \
    EMBEDDING_BASE_PATH=http://127.0.0.1:11434 \
    EMBEDDING_MODEL_PREF=nomic-embed-text:latest \
    EMBEDDING_MODEL_MAX_CHUNK_LENGTH=8192 \
    VECTOR_DB=lancedb \
    WHISPER_PROVIDER=local \
    TTS_PROVIDER=native \
    PASSWORDMINCHAR=8

# 创建必要的目录
RUN mkdir -p /app/server/storage

# 暴露服务端口
EXPOSE 11434

# 定义默认启动命令
CMD ["npm", "run", "start"]
