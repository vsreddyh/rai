#!/bin/bash

OUTPUT_FILE="./model.csv"

RESPONSE=$(curl -s https://openrouter.ai/api/v1/models)

sqlite3 "$DB_FILE" <<EOF
DROP TABLE IF EXISTS models;
CREATE TABLE models (
	tag TEXT,
    series TEXT,
    name TEXT,
    status TEXT
);
EOF

echo "$RESPONSE" | jq -r '
  .data[] | 
	  "\(.id),\(.name | split(":")[0]),\(.name | split(": ")[1]),\(
    if ((.pricing.prompt? // "0") | tonumber) == 0 and ((.pricing.completion? // "0") | tonumber) == 0 
    then "free," 
    else "paid," 
    end
  )"' >"$OUTPUT_FILE"

echo "Models saved to $OUTPUT_FILE"
