# Repository Guidelines

## Project Structure & Module Organization
- `Dockerfile` builds the custom MongoDB image used in CI and local builds.
- `docker-compose.yml` runs MongoDB plus the `mongo-seed` container for data loading.
- `docker-compose-stack.yml` is the swarm/Portainer stack definition with an NFS-backed volume.
- `docker-compose-mongodb-community.yml` is a minimal community server example.
- `mongo-seed/` contains the seed image (`Dockerfile`), `init.sh`, and JSON data under `collections/`.

## Build, Test, and Development Commands
- `docker image build -t kernel528/mongodb:8.2.3-ubuntu2204 -f Dockerfile .` builds the base image locally.
- `docker-compose up --build` starts MongoDB plus the seed container and imports JSON data.
- `docker container run -it --name mongodb-obiwan -d -p 27017:27017 -v mongo-obiwan-data:/data/db mongodb/mongodb-community-server:8.0.4-ubuntu2204` runs a standalone MongoDB container.
- Drone CI in `.drone.yml` builds and tags images, then runs a simple `mongod --version` smoke check.

## Coding Style & Naming Conventions
- YAML files use 2-space indentation; shell scripts use 2-space indentation where applicable.
- Docker tags follow `MAJOR.MINOR.PATCH` and append build qualifiers like `-amd64` when needed.
- Environment variables in compose files use uppercase snake case (e.g., `MONGO_INITDB_ROOT_USERNAME`).

## Testing Guidelines
- No dedicated test framework in this repo; CI uses a lightweight image smoke test in `.drone.yml`.
- If you add scripts, keep them idempotent and runnable in containers (see `mongo-seed/init.sh`).

## Commit & Pull Request Guidelines
- No explicit commit convention is documented. Use clear, scoped messages such as `Update base image to 8.2.3`.
- PRs should note the MongoDB version/tag change, relevant compose file updates, and any seed data edits.
- If the change affects runtime behavior, include the exact command used to verify it.

## Configuration & Security Notes
- Avoid committing secrets; rely on environment variables for credentials.
- Seed data is loaded via `mongo-seed/init.sh` using `MONGO_URI` and JSON files under `mongo-seed/collections/`.
