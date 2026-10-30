[![Build Status](https://drone.kernelsanders.biz:8443/api/badges/kernel528/mongo-docker/status.svg?ref=refs/heads/main)](https://drone.kernelsanders.biz:8443/kernel528/mongo-docker)
[![Latest Version](https://img.shields.io/github/v/tag/kernel528/mongo-docker)](https://github.com/kernel528/mongo-docker/releases/latest)

### MongoDB Community Edition Docker Image
This repository mirrors the official `mongodb/mongodb-community-server` image. The workflow copies the latest upstream release, retags it under `kernel528/mongodb-community-server`, and uses that tag as the base image for local validation and CI builds. Target platform: `linux/amd64`.

### Project Structure
```
project-root/
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
VERSION=9.0.4

docker image pull mongodb/mongodb-community-server:${VERSION}-ubuntu2204 --platform linux/amd64
docker image tag mongodb/mongodb-community-server:${VERSION}-ubuntu2204 \
  kernel528/mongodb-community-server:${VERSION}-ubuntu2204-amd64
docker image inspect mongodb/mongodb-community-server:${VERSION}-ubuntu2204 \
  --format '{{index .RepoDigests 0}}'
docker image push kernel528/mongodb-community-server:${VERSION}-ubuntu2204-amd64
```
For this refresh, the upstream image digest is `sha256:dfbdcffe2186ec2809473b833278f0663dd9a70d42d2e1b332be4bed870dd40c`.
2) Update `Dockerfile` to reference the new `kernel528/mongodb-community-server` tag.
3) Review `mongo-seed/Dockerfile` at the same time. Keep it on the same mirrored MongoDB base unless an intentional compatibility reason for a different version is documented.
4) Update `.drone.yml` tags as needed. PRs targeting `9` perform a dry-run build plus ping/CRUD and seed-import smoke tests against the mirrored base image, pushes to `main` publish and test `latest`, and Git tags publish the exact `${DRONE_TAG}` release. The upstream mirror push remains manual, so keep the Dockerfile and CI test tags aligned with that mirrored base image.
5) Build and smoke-test before publishing an immutable release tag.
6) Update and validate the Swarm stack only after the release tag resolves.

### Repository Relationships

This repository follows an independent MongoDB upstream mirror cadence and does not consume `kernel528/alpine`. [`docker-workspace`](https://github.com/kernel528/docker-workspace) coordinates its release state, while [`docker-swarm`](https://github.com/kernel528/docker-swarm) consumes the published image through `stacks/mongo-stack.yml`. Keep mirroring, image release, and persistence-sensitive Swarm deployment as separate reviewed steps.

### Build Base Image Locally
```bash
docker image build -t kernel528/mongodb-community-server:${VERSION}-ubuntu2204-amd64 -f Dockerfile .
```

### Docker Swarm Validation
This repo is tested via the external stack file:
```bash
docker stack deploy -c ../docker-swarm/stacks/mongo-stack.yml mongodb
```

### How to Use - Standalone
```bash
docker container run -it --name mongodb-obiwan --hostname mongo-docker -d \
  -p 27017:27017 -v mongo-obiwan-data:/data/db \
  kernel528/mongodb-community-server:${VERSION}-ubuntu2204-amd64
```
- No-auth example: `mongodb://localhost:27017`
- With auth: `mongodb://<user>:<pass>@localhost:27017/?authSource=admin`

### Seed Data
The `mongo-seed/init.sh` script imports JSON files under `mongo-seed/collections/sample_*/*.json`.
Set `MONGO_URI` to the target database and optionally set `COLLECTIONS_DIR` to override the default collections path.
