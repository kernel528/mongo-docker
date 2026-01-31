#!/bin/bash

# Wait for MongoDB to be ready
until mongosh "${MONGO_URI}" --eval "print(\"waiting for connection\")"
do
    sleep 5
done

# Import each JSON file in the collections directory
COLLECTIONS_DIR="${COLLECTIONS_DIR:-/collections}"
for file in "${COLLECTIONS_DIR}"/sample_*/*.json
do
    collection=$(basename "$file" .json)
    echo "Importing $file into collection $collection"
    mongoimport --uri "${MONGO_URI}" --collection "$collection" --file "$file" --jsonArray
done

echo "Data import completed."
