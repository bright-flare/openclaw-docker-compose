# npm 설치시간 단축을 위해 node:22 이미지 사용
FROM node:22-bookworm

SHELL ["/bin/bash", "-c"]

# 필수 패키지 설치 (apt update & install 묶음), chrominum 브라우저 설치
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    jq \
    git \
    chromium \
    fonts-liberation \
    xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# OpenClaw 글로벌 설치
RUN which node && node -v && npm -v && npm i -g openclaw

# 기본 작업 디렉토리 설정
WORKDIR /workspace

# 실행 시 기본 쉘
CMD ["bash"]
