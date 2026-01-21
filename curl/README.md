# Curl Examples

These scripts demonstrate how to call the PartFuse API using `curl`.

## Setup

1. Copy `.env.example` from the root to `.env` in the root directory and fill in your RapidAPI Key.
2. Make scripts executable:
   ```bash
   chmod +x *.sh
   ```

## Usage

```bash
# Search
./search.sh "LM7805"

# Compare
./compare.sh "STM32F103C8T6" 10

# BOM Compare
./bom_compare.sh

# Health/Ping
./health.sh
./ping.sh
```

## Dependencies
- `curl`
- `jq` (optional, for pretty printing json output if you want to pipe: `./search.sh | jq`)
