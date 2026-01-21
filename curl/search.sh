#!/bin/bash

# Load environment variables
if [ -f ../.env ]; then
  export $(cat ../.env | grep -v '#' | awk '/=/ {print $1}')
fi

# Defaults
PARTFUSE_RAPIDAPI_KEY=${PARTFUSE_RAPIDAPI_KEY:-""}
PARTFUSE_RAPIDAPI_HOST=${PARTFUSE_RAPIDAPI_HOST:-"partfuse.p.rapidapi.com"}
PARTFUSE_BASE_URL=${PARTFUSE_BASE_URL:-"https://partfuse.p.rapidapi.com"}

if [ -z "$PARTFUSE_RAPIDAPI_KEY" ]; then
  echo "Error: PARTFUSE_RAPIDAPI_KEY is not set."
  echo "Please set it in ../.env or export it in your shell."
  exit 1
fi

QUERY=${1:-"LM7805"}

echo "Searching for: $QUERY"

curl -s --request GET \
	--url "$PARTFUSE_BASE_URL/api/v1/search?q=$QUERY" \
	--header "X-RapidAPI-Key: $PARTFUSE_RAPIDAPI_KEY" \
	--header "X-RapidAPI-Host: $PARTFUSE_RAPIDAPI_HOST"
