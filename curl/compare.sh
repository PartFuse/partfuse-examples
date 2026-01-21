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

PART_NUMBER=${1:-"STM32F103C8T6"}
QTY=${2:-1}

echo "Comparing prices for: $PART_NUMBER (Qty: $QTY)"

curl -s --request GET \
	--url "$PARTFUSE_BASE_URL/api/v1/compare/$PART_NUMBER?qty=$QTY" \
	--header "X-RapidAPI-Key: $PARTFUSE_RAPIDAPI_KEY" \
	--header "X-RapidAPI-Host: $PARTFUSE_RAPIDAPI_HOST"
