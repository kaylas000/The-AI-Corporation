import asyncio
from typing import List
import aiohttp

async def fetch_user_data(user_ids: List[str]) -> List[dict]:
    """
    Fetch multiple users concurrently.
    
    Args:
        user_ids: List of user IDs to fetch
        
    Returns:
        List of user data dictionaries
    """
    async with aiohttp.ClientSession() as session:
        tasks = [_fetch_one(session, uid) for uid in user_ids]
        results = await asyncio.gather(*tasks, return_exceptions=True)
        
        # Filter out errors
        return [r for r in results if isinstance(r, dict)]

async def _fetch_one(session: aiohttp.ClientSession, user_id: str) -> dict:
    """Helper to fetch single user."""
    url = f"https://api.example.com/users/{user_id}"
    async with session.get(url) as response:
        return await response.json()
