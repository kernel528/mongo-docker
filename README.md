### MongoDB Community Edition Docker Image

### Project Structure
project-root/
├── docker-compose.yml
├── mongo-seed/
│   ├── Dockerfile
│   ├── init.sh
│   └── collections/
│       ├── collectionName
|           |__ collection1.json
│           └── collection2.json

### Build Base Image
```aiignore
docker image build -t kernel528/mongodb:8.0.4-ubuntu2204 -f Dockerfile .
```

### How to Use - Standalone
```aiignore

```

### How to Use - docker-compose (TBD)
