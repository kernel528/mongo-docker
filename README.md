[![Build Status](http://drone.kernelsanders.biz:8080/api/badges/kernel528/mongo-docker/status.svg?ref=refs/heads/main)](http://drone.kernelsanders.biz:8080/kernel528/mongo-docker)
[![Latest Version](https://img.shields.io/github/v/tag/kernel528/mongo-docker)](https://github.com/kernel528/mongo-docker/releases/latest)

### MongoDB Community Edition Docker Image
This repository mirrors the official `mongodb/mongodb-community-server` image. The workflow copies the latest upstream release, retags it under `kernel528/mongodb-community-server`, and uses that tag as the base image for local validation and CI builds. Target platform: `linux/amd64`.

### Project Structure
```
project-root/
├── docker-compose.yml
├── docker-compose-stack.yml
├── docker-compose-mongodb-community.yml
├── Dockerfile
├── mongo-seed/
│   ├── Dockerfile
│   ├── init.sh
│   └── collections/
│       └── sample_*/
│           └── *.json
```

### Workflow: Mirror Upstream Image
1) Pull the latest upstream image and retag it for Docker Hub:
```bash
VERSION=8.2.3

docker image pull mongodb/mongodb-community-server:${VERSION}-ubuntu2204 --platform linux/amd64
docker image tag mongodb/mongodb-community-server:${VERSION}-ubuntu2204 \
  kernel528/mongodb-community-server:${VERSION}-ubuntu2204-amd64
docker image push kernel528/mongodb-community-server:${VERSION}-ubuntu2204-amd64
```
2) Update `Dockerfile` to reference the new `kernel528/mongodb-community-server` tag.
3) Update `.drone.yml` tags as needed (CI publishes `latest`, `8`, and explicit version tags on `main` push and tags, for example `8.2.4` and `8.2.4-drone-build-<build>-amd64`). This step is manual today, so keep the tags in sync with the mirrored base image.
4) Validate via the swarm stack (see below).

### Build Base Image Locally
```bash
docker image build -t kernel528/mongodb:${VERSION}-ubuntu2204 -f Dockerfile .
```

### Docker Swarm Validation
This repo is tested via the external stack file:
```bash
docker stack deploy -c ../docker-swarm/stacks/mongo-stack.yml mongo
```

### How to Use - Standalone
```bash
docker container run -it --name mongodb-obiwan --hostname mongo-docker -d \
  -p 27017:27017 -v mongo-obiwan-data:/data/db \
  kernel528/mongodb-community-server:${VERSION}-ubuntu2204-amd64
```
- No-auth example: `mongodb://localhost:27017`
- With auth: `mongodb://<user>:<pass>@localhost:27017/?authSource=admin`

### How to Use - docker-compose (Work in Progress)
```bash
docker-compose up --build
```
- The `mongo-seed` container runs `mongo-seed/init.sh` and imports all JSON files under `mongo-seed/collections/sample_*/*.json`.
- Ensure required environment variables are set (e.g., `MONGO_INITDB_ROOT_USERNAME`, `MONGO_INITDB_ROOT_PASSWORD`, `MONGO_HOSTNAME`, `MONGO_DATABASE_NAME`).
