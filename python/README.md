# PartFuse Python Examples

This directory contains Python examples calling the PartFuse API using `requests` (sync) and `httpx` (async).

## Setup

1.  **Environment**:
    ```bash
    cp ../.env.example .env
    # Edit .env and set your PARTFUSE_RAPIDAPI_KEY
    ```

2.  **Install Dependencies**:
    ```bash
    pip install -r requirements.txt
    ```

## Usage

Run the examples as modules:

```bash
# Search
python -m partfuse_examples.search "STM32F4" --limit 3

# Single Part Compare
python -m partfuse_examples.compare "LM317T" --qty 50

# BOM Compare
# Reads bom.json by default
python -m partfuse_examples.bom
```

## Structure
- `partfuse_examples/client.py`: Reusable client wrapper with error handling.
- `partfuse_examples/*.py`: CLI entrypoints.
