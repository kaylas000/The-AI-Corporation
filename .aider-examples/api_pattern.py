from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel, EmailStr
from typing import List

router = APIRouter(prefix="/users", tags=["users"])

class UserCreate(BaseModel):
    """Request model for creating user."""
    email: EmailStr
    name: str

class UserResponse(BaseModel):
    """Response model for user data."""
    id: str
    email: str
    name: str

@router.post("/", response_model=UserResponse, status_code=201)
async def create_user(
    user: UserCreate,
    db = Depends(get_database)
) -> UserResponse:
    """
    Create new user.
    
    Args:
        user: User creation data
        db: Database dependency
        
    Returns:
        Created user data
        
    Raises:
        HTTPException: If email already exists
    """
    if await db.user_exists(user.email):
        raise HTTPException(
            status_code=400,
            detail=f"User with email {user.email} already exists"
        )
    
    new_user = await db.create_user(user)
    return UserResponse(**new_user)
