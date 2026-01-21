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

echo "Pinging..."

curl -s --request GET \
	--url "$PARTFUSE_BASE_URL/ping" \
	--header "X-RapidAPI-Key: $PARTFUSE_RAPIDAPI_KEY" \
	--header "X-RapidAPI-Host: $PARTFUSE_RAPIDAPI_HOST"
