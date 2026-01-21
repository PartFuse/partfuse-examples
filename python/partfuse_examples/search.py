import sys
import json
import argparse
from .client import PartFuseClient

def main():
    parser = argparse.ArgumentParser(description="PartFuse Search Example")
    parser.add_argument("query", help="Part number to search for")
    parser.add_argument("--limit", type=int, default=5, help="Max results")
    args = parser.parse_args()

    client = PartFuseClient()
    
    try:
        print(f"Searching for '{args.query}'...")
        result = client.search(args.query, args.limit)
        print(json.dumps(result, indent=2))
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
