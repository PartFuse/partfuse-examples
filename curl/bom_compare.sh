#!/bin/bash

if [ -f ../.env ]; then
  export $(cat ../.env | grep -v '#' | awk '/=/ {print $1}')
fi

PARTFUSE_RAPIDAPI_KEY=${PARTFUSE_RAPIDAPI_KEY:-""}
PARTFUSE_RAPIDAPI_HOST=${PARTFUSE_RAPIDAPI_HOST:-"partfuse.p.rapidapi.com"}
PARTFUSE_BASE_URL=${PARTFUSE_BASE_URL:-"https://partfuse.p.rapidapi.com"}

if [ -z "$PARTFUSE_RAPIDAPI_KEY" ]; then
  echo "Error: PARTFUSE_RAPIDAPI_KEY is not set."
  exit 1
fi

# Create a temporary BOM file if not exists
cat <<EOF > temp_bom.json
{
  "lines": [
    { "mpn": "LM7805", "quantity": 10, "reference": "U1" },
    { "mpn": "NE555", "quantity": 50, "reference": "U2" }
  ]
}
EOF

echo "Uploading BOM comparison..."

curl -s --request POST \
	--url "$PARTFUSE_BASE_URL/api/v1/bom/compare" \
	--header "Content-Type: application/json" \
	--header "X-RapidAPI-Key: $PARTFUSE_RAPIDAPI_KEY" \
	--header "X-RapidAPI-Host: $PARTFUSE_RAPIDAPI_HOST" \
	--data @temp_bom.json

rm temp_bom.json
