# PartFuse Go Example

A simple CLI tool written in Go to interact with the PartFuse API.

## Setup

1. Copy `.env.example` to `.env` in the root (scripts look for environment variables).
2. Set `PARTFUSE_RAPIDAPI_KEY` in your environment manually:
   ```bash
   export PARTFUSE_RAPIDAPI_KEY=your_key
   ```
   *(Or rely on the provided `.env` if you add a loader like godotenv, but this example uses pure stdlib so you must export env vars manually).*

## Usage

```bash
# Search
go run main.go search "STM32" --limit 3

# Compare
go run main.go compare "LM7805" --qty 10

# BOM (uses hardcoded sample)
go run main.go bom

# Health
go run main.go health
```
