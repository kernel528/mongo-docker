[![Build Status](http://drone.kernelsanders.biz:8080/api/badges/kernel528/mongo-docker/status.svg?ref=refs/heads/main)](http://drone.kernelsanders.biz:8080/kernel528/mongo-docker)
[![Latest Version](https://img.shields.io/github/v/tag/kernel528/mongo-docker)](https://github.com/kernel528/mongo-docker/releases/latest)


### MongoDB Community Edition Docker Image
This is based on the mongodb/mongodb-community-server:8.0.15-ubuntu2204 --platform=linux/amd64

### Project Structure
```
project-root/
├── docker-compose.yml
├── mongo-seed/
│   ├── Dockerfile
│   ├── init.sh
│   └── collections/
│       ├── collectionName
|           |__ collection1.json
│           └── collection2.json
```
### Base Image Prep Steps
- Pull upstream mongodb/mongodb-community-server:VERSION image, tag to kernel528/mongodb-community-server:VERSION, Push image... 
   ```bash
     : docker image pull mongodb/mongodb-community-server:8.0.7-ubuntu2204-20250725T075524Z --platform linux/amd64
     
     : docker image ls | grep mongodb
     mongodb/mongodb-community-server   8.0.7-ubuntu2204-20250725T075524Z   93a6d70c235a   23 hours ago   1.26GB
     
     : docker image tag 93a6d70c235a kernel528/mongodb-community-server:8.0.7-ubuntu2204-20250725T075524Z-amd64
     
     : docker image push kernel528/mongodb-community-server:8.0.7-ubuntu2204-20250725T075524Z-amd64
   ```
- Update the Dockerfile with the new base image to pull.
- Update the .drone.yml with updated version tags.

### Build Base Image
```aiignore
docker image build -t kernel528/mongodb:8.0.4-ubuntu2204 -f Dockerfile .
```

### Drone Builds
- This uses the kernel528/mongodb-community-server docker hub source `FROM`.
- This is a copy of the main mongodb/mongodb-community-server source hub.
- The .drone.yml base configuration just rebuilds this with potential configuration customizations into kernel528/mongodb.

### Refreshing
- Download the latest image from docker hub repo.
- Tag to kernel528/mongodb-community-server:8.04-ubuntu2204-VERSION-amd64
- Push image to kernel528 docker hub repo.
- Update Dockerfile to use the new version.
- Update .drone.yml if needed.
- Commit changes and push to git repo.
- Confirm drone build.
- Update docker swarm stack & confirm redeploy.

### How to Use - Standalone
```aiignore
docker container run -it --name mongodb-obiwan --hostname mongo-docker -d -p 27017:27017 -v mongo-obiwan-data:/data/db mongodb/mongodb-community-server:8.0.4-ubuntu2204
```
- Then can use MongoDB Compass to connect to DB at mongodb://localhost:27017 (no auth)
- The customized [starter-express-mongoose](https://github.com/kernel528/starter-express-mongoose) can be used to launch a local mongoose node app.
  - This is just currently setup to support a /users route for testing.

### Docker Swarm Deployment
- The `docker-compose-stack.yml` is the base configuration to deploy using docker swarm cluster.
- This is deployed using the `portainer` based manager for the cluster.
- This includes a NAS hosted volume to provide data persistence.

### How to Use - docker-compose (_Work in Progress_)
- This is a work in progress
- Run the command below from the top-level to run a default build and start. 
- This will also run the `mongo-seed` container with the `init.sh` script to seed some data.
- Currently only the famous-quotes is working automatically with `mongoimport` in the script.
```aiignore
docker-compose up --build
```
- The MongoDB Compass connection string will require 
