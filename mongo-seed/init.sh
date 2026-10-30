#!/bin/bash

# Wait for MongoDB to be ready
until mongosh "${MONGO_URI}" --eval "print(\"waiting for connection\")"
do
    sleep 5
done

# Import each JSON file in the collections directory
COLLECTIONS_DIR="${COLLECTIONS_DIR:-/collections}"
failed=0
for file in "${COLLECTIONS_DIR}"/sample_*/*.json
do
    collection=$(basename "$file" .json)
    # Files starting with '[' are JSON arrays; everything else is one document per line.
    format_args=()
    if [ "$(head -c 64 "$file" | tr -d '[:space:]' | cut -c1)" = "[" ]; then
        format_args=(--jsonArray)
    fi
    echo "Importing $file into collection $collection"
    if ! mongoimport --uri "${MONGO_URI}" --collection "$collection" --file "$file" "${format_args[@]}"; then
        echo "ERROR: import failed for $file" >&2
        failed=$((failed + 1))
    fi
done

if [ "$failed" -gt 0 ]; then
    echo "Data import completed with $failed failed file(s)." >&2
    exit 1
fi

echo "Data import completed."
