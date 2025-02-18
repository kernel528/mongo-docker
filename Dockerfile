#FROM mongodb/mongodb-community-server:8.0.4-ubuntu2204
FROM kernel528/mongodb-community-server:8.0.4-ubuntu2204-arm64
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
