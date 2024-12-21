#!/bin/bash

# Wait for MongoDB to be ready
until mongosh "${MONGO_URI}" --eval "print(\"waiting for connection\")"
do
    sleep 5
done

# Import each JSON file in the /collections directory
for file in /collections/sample_*/*.json
do
    collection=$(basename "$file" .json)
    echo "Importing $file into collection $collection"
    mongoimport --uri "${MONGO_URI}" --collection "$collection" --file "$file" --jsonArray
done

echo "Data import completed."
