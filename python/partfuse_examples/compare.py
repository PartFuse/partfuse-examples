import sys
import json
import argparse
from .client import PartFuseClient

def main():
    parser = argparse.ArgumentParser(description="PartFuse Compare Example")
    parser.add_argument("part_number", help="Part number to compare")
    parser.add_argument("--qty", type=int, default=1, help="Quantity")
    args = parser.parse_args()

    client = PartFuseClient()
    
    try:
        print(f"Comparing '{args.part_number}' (Qty: {args.qty})...")
        result = client.compare(args.part_number, args.qty)
        print(json.dumps(result, indent=2))
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
