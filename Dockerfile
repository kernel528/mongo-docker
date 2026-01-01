# This is based on mongodb/mongodb-community-server:8.0.7-ubuntu2204 --platform=linux/amd64
FROM kernel528/mongodb-community-server:8.2.3-ubuntu2204-amd64
LABEL authors="kernel528@gmail.com"

# Set environment variables for MongoDB initialization
# ENV MONGO_INITDB_ROOT_USERNAME=root
# ENV MONGO_INITDB_ROOT_PASSWORD=example

# Expose the default MongoDB port
EXPOSE 27017

# Optional: Change to a non-root user if security is a concern
USER mongodb

# Start the MongoDB server
CMD ["mongod"]
