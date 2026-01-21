#!/bin/bash

if [ -f ../.env ]; then
  export $(cat ../.env | grep -v '#' | awk '/=/ {print $1}')
fi

PARTFUSE_RAPIDAPI_KEY=${PARTFUSE_RAPIDAPI_KEY:-""}
PARTFUSE_RAPIDAPI_HOST=${PARTFUSE_RAPIDAPI_HOST:-"partfuse.p.rapidapi.com"}
PARTFUSE_BASE_URL=${PARTFUSE_BASE_URL:-"https://partfuse.p.rapidapi.com"}

# Health technically doesn't require auth on some setups, but RapidAPI always enforces headers
if [ -z "$PARTFUSE_RAPIDAPI_KEY" ]; then
  echo "Error: PARTFUSE_RAPIDAPI_KEY is not set."
  exit 1
fi

echo "Checking Health..."

curl -s --request GET \
	--url "$PARTFUSE_BASE_URL/health" \
	--header "X-RapidAPI-Key: $PARTFUSE_RAPIDAPI_KEY" \
	--header "X-RapidAPI-Host: $PARTFUSE_RAPIDAPI_HOST"
