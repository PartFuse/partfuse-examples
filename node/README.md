# PartFuse Node.js Examples

Examples using native `fetch` (Node 18+) and `axios`.

## Setup
1. Copy `.env.example` to `.env` in the root:
   ```bash
   cp ../.env.example .env
   ```
2. Install dependencies:
   ```bash
   npm install
   ```

## Usage

```bash
# Search
npm run search -- "ATMEGA328P"

# Compare
npm run compare -- "STM32F407" 10

# BOM Compare (reads bom.json)
npm run bom
```
