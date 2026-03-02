# openclaw-docker-compose

OpenClaw 실행 환경을 Docker Compose + Nginx 리버스 프록시로 구성한 저장소입니다.

- 외부 진입점: `http://localhost` (host `80:80`)
- 내부 라우팅:
  - `/` -> `openclaw-base:18789` (대시보드)
  - `/chrome` -> `openclaw-base:18792` (Chrome Extension 연동용)

## 구성 파일

- `docker-compose.yml`: 컨테이너/네트워크/볼륨/포트 정의
- `nginx.conf`: 리버스 프록시 라우팅 및 헤더 설정
- `Dockerfile`: `ubuntu:24.04` 기반 OpenClaw 실행 이미지

## 사전 요구사항

- Docker
- Docker Compose (Docker Desktop 포함)
- 로컬 디렉토리
  - `$HOME/Documents/openclaw/openclaw-workspace`
  - `$HOME/Documents/openclaw/openclaw-data`

## 빠른 시작

```bash
docker compose up -d --build
```

컨테이너 상태 확인:

```bash
docker compose ps
```

`openclaw-base` 셸 접속:

```bash
docker compose exec openclaw-base bash
```

## 서비스 실행 포인트

`openclaw-base` 컨테이너 안에서 실제 서비스 프로세스를 띄워야 Nginx가 정상 프록시합니다.

- 대시보드 서비스: `0.0.0.0:18789`로 바인딩
- extension 연동 서비스: `0.0.0.0:18792`로 바인딩

위 포트에 프로세스가 없으면 Nginx에서 `502 Bad Gateway`가 발생합니다.

## 접속 경로

- 대시보드: `http://localhost/`
- Chrome Extension endpoint: `http://localhost/chrome`

## 로그 확인

Nginx 로그:

```bash
docker compose logs -f proxy
```

OpenClaw 컨테이너 로그:

```bash
docker compose logs -f openclaw-base
```

## 중지/정리

```bash
docker compose stop
```

볼륨까지 포함해 완전 정리:

```bash
docker compose down -v
```

## 포트 정책 변경 가이드

현재는 `80:80` 단일 진입점입니다.

만약 `localhost:18789` 또는 `localhost:18792`처럼 포트 직접 접근이 필요하면:

1. `docker-compose.yml`의 `proxy.ports`에 host 포트를 추가
2. `nginx.conf`에 해당 `listen` 서버 블록 추가
3. `docker compose up -d --force-recreate`로 재기동

## 트러블슈팅

- `502 Bad Gateway`
  - `openclaw-base` 내부에서 대상 포트(18789/18792)에 서비스가 실제로 떠 있는지 확인
- 접속 불가
  - `docker compose ps`로 컨테이너 상태 확인
  - `docker compose logs -f proxy`로 Nginx 에러 확인
- compose 경고: `version is obsolete`
  - 동작에는 영향 없지만 `docker-compose.yml`의 `version` 필드는 제거해도 됩니다.
