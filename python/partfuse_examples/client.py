import os
import time
import requests
import httpx
from typing import Optional, Dict, Any

class PartFuseClient:
    def __init__(self, api_key: str = None):
        self.api_key = api_key or os.getenv("PARTFUSE_RAPIDAPI_KEY")
        if not self.api_key:
            raise ValueError("API Key is required. Set PARTFUSE_RAPIDAPI_KEY env var.")
        
        self.host = os.getenv("PARTFUSE_RAPIDAPI_HOST", "partfuse.p.rapidapi.com")
        self.base_url = os.getenv("PARTFUSE_BASE_URL", "https://partfuse.p.rapidapi.com")
        
        self.headers = {
            "X-RapidAPI-Key": self.api_key,
            "X-RapidAPI-Host": self.host,
            "Content-Type": "application/json"
        }

    def _handle_response(self, response: requests.Response) -> Dict[str, Any]:
        if response.status_code == 429:
            retry_after = response.headers.get("Retry-After")
            print(f"Rate limit exceeded. Retry after: {retry_after}s")
            raise Exception("Rate limit exceeded")
        
        try:
            response.raise_for_status()
            return response.json()
        except requests.exceptions.HTTPError as e:
            print(f"HTTP Error: {e}")
            if response.content:
                print(f"Body: {response.text}")
            raise

    def search(self, query: str, limit: int = 10) -> Dict[str, Any]:
        """Synchronous search using requests"""
        url = f"{self.base_url}/api/v1/search"
        params = {"q": query, "limit": limit}
        
        # Simple retry logic for demonstration
        for attempt in range(3):
            try:
                resp = requests.get(url, headers=self.headers, params=params, timeout=10)
                return self._handle_response(resp)
            except Exception as e:
                print(f"Attempt {attempt+1} failed: {e}")
                if attempt == 2: raise
                time.sleep(1 * (attempt + 1))

    def compare(self, part_number: str, qty: int = 1) -> Dict[str, Any]:
        """Synchronous compare"""
        url = f"{self.base_url}/api/v1/compare/{part_number}"
        params = {"qty": qty}
        
        resp = requests.get(url, headers=self.headers, params=params, timeout=10)
        return self._handle_response(resp)

    def bom_compare(self, bom_data: Dict[str, Any]) -> Dict[str, Any]:
        """Synchronous BOM upload"""
        url = f"{self.base_url}/api/v1/bom/compare"
        resp = requests.post(url, headers=self.headers, json=bom_data, timeout=30)
        return self._handle_response(resp)


class AsyncPartFuseClient:
    def __init__(self, api_key: str = None):
        self.api_key = api_key or os.getenv("PARTFUSE_RAPIDAPI_KEY")
        if not self.api_key:
            raise ValueError("API Key is required.")
        
        self.host = os.getenv("PARTFUSE_RAPIDAPI_HOST", "partfuse.p.rapidapi.com")
        self.base_url = os.getenv("PARTFUSE_BASE_URL", "https://partfuse.p.rapidapi.com")
        self.headers = {
            "X-RapidAPI-Key": self.api_key,
            "X-RapidAPI-Host": self.host,
            "Content-Type": "application/json"
        }

    async def search(self, query: str, limit: int = 10) -> Dict[str, Any]:
        """Async search using httpx"""
        url = f"{self.base_url}/api/v1/search"
        params = {"q": query, "limit": limit}
        
        async with httpx.AsyncClient() as client:
            resp = await client.get(url, headers=self.headers, params=params, timeout=10.0)
            resp.raise_for_status()
            return resp.json()
