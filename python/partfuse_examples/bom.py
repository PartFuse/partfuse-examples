import sys
import json
import argparse
import os
from .client import PartFuseClient

def main():
    parser = argparse.ArgumentParser(description="PartFuse BOM Compare Example")
    parser.add_argument("--file", help="Path to BOM JSON file", default="bom.json")
    args = parser.parse_args()

    client = PartFuseClient()
    
    # Sample BOM if file doesn't exist
    if not os.path.exists(args.file):
        print(f"File {args.file} not found. Using embedded sample.")
        bom_data = {
            "lines": [
                { "mpn": "LM7805", "quantity": 10, "reference": "Regulator" },
                { "mpn": "ATMEGA328P-PU", "quantity": 5, "reference": "MCU" }
            ]
        }
    else:
        with open(args.file, 'r') as f:
            bom_data = json.load(f)

    try:
        print("Uploading BOM...")
        result = client.bom_compare(bom_data)
        print(json.dumps(result, indent=2))
    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
