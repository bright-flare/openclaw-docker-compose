# 1. 베이스 이미지 설정
FROM ubuntu:24.04

# 2. 환경 변수 설정 (터미널 인터랙션 방지 및 nvm 경로)
ENV DEBIAN_FRONTEND=noninteractive
ENV NVM_DIR=/root/.nvm
ENV NODE_VERSION=22

SHELL ["/bin/bash", "-lc"]

# 3. 필수 패키지 설치 (apt update & install 묶음)
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    jq \
    git \
    && rm -rf /var/lib/apt/lists/*

# 4. NVM 및 Node.js 설치
# 도커 환경에서는 bashrc 로드보다 직접 경로를 지정하는 것이 확실합니다.
RUN curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm use $NODE_VERSION \
    && nvm alias default $NODE_VERSION

# 5. Node.js 환경 변수 등록 (컨테이너 접속 시 바로 node/npm 사용 가능하게)
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"

# 6. OpenClaw 글로벌 설치
RUN node -v && npm -v && npm i -g openclaw

# 7. 기본 작업 디렉토리 설정
WORKDIR /workspace

# 8. 실행 시 기본 쉘
CMD ["bash"]
