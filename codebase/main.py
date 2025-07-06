#!/usr/bin/env python3
"""
Sample FastAPI application with some code smells for testing the dual-agent workflow.
"""

import os
import sys
from typing import Dict, List, Optional
import json
import requests
import time
import datetime

# Global variables (code smell)
API_KEY = "hardcoded_secret_key_123"
DEBUG_MODE = True
CACHE = {}

def get_user_data(user_id: int) -> Dict:
    """Get user data from API."""
    url = f"https://api.example.com/users/{user_id}"
    headers = {"Authorization": f"Bearer {API_KEY}"}

    try:
        response = requests.get(url, headers=headers)
        response.raise_for_status()
        return response.json()
    except requests.RequestException as e:
        print(f"Error: {e}")
        return {}

def process_data(data: List) -> List:
    """Process a list of data items."""
    result = []
    for item in data:
        # Nested loops (code smell)
        for subitem in item.get('subitems', []):
            for detail in subitem.get('details', []):
                if detail.get('active'):
                    result.append(detail)
    return result

def calculate_total(items: List[Dict]) -> float:
    """Calculate total from items."""
    total = 0.0
    for item in items:
        total += item.get('price', 0) * item.get('quantity', 1)
    return total

def save_to_file(filename: str, data: Dict) -> bool:
    """Save data to file."""
    try:
        with open(filename, 'w') as f:
            json.dump(data, f)
        return True
    except Exception as e:
        print(f"Error saving file: {e}")
        return False

def main():
    """Main function."""
    print("Starting application...")

    # Hardcoded values (code smell)
    user_id = 12345
    filename = "output.json"

    # Get user data
    user_data = get_user_data(user_id)

    # Process data
    processed_data = process_data(user_data.get('items', []))

    # Calculate total
    total = calculate_total(processed_data)

    # Save results
    result = {
        'user_id': user_id,
        'total': total,
        'timestamp': datetime.datetime.now().isoformat()
    }

    save_to_file(filename, result)
    print(f"Total: ${total}")

if __name__ == "__main__":
    main()
