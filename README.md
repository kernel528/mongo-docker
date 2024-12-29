[![Drone Build Status](http://drone.kernelsanders.biz:8080/api/badges/kernel528/mongo-docker/status.svg)](http://drone.kernelsanders.biz:8080/kernel528/mongo-docker)                      
[![Latest Version](https://img.shields.io/github/v/tag/kernel528/mongo-docker)](https://github.com/kernel528/mongo-docker/releases/latest)


### MongoDB Community Edition Docker Image

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
### Build Base Image
```aiignore
docker image build -t kernel528/mongodb:8.0.4-ubuntu2204 -f Dockerfile .
```

### How to Use - Standalone
```aiignore
docker container run -it --name mongodb-obiwan --hostname mongo-docker -d -p 27017:27017 -v mongo-obiwan-data:/data/db mongodb/mongodb-community-server:8.0.4-ubuntu2204
```
- Then can use MongoDB Compass to connect to DB at mongodb://localhost:27017 (no auth)
- The customized [starter-express-mongoose](https://github.com/kernel528/starter-express-mongoose) can be used to launch a local mongoose node app.
  - This is just currently setup to support a /users route for testing.

### How to Use - docker-compose (_Work in Progress_)
- This is a work in progress
- Run the command below from the top-level to run a default build and start. 
- This will also run the `mongo-seed` container with the `init.sh` script to seed some data.
- Currently only the famous-quotes is working automatically with `mongoimport` in the script.
```aiignore
docker-compose up --build
```
- The MongoDB Compass connection string will require 
