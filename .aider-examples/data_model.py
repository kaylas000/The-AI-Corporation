from dataclasses import dataclass, field
from datetime import datetime
from typing import List

@dataclass
class User:
    """User data model with automatic validation."""
    
    id: str
    email: str
    created_at: datetime = field(default_factory=datetime.now)
    tags: List[str] = field(default_factory=list)
    
    def __post_init__(self):
        """Validate data after initialization."""
        if not self.email or "@" not in self.email:
            raise ValueError(f"Invalid email: {self.email}")
    
    def add_tag(self, tag: str) -> None:
        """Add tag if not already present."""
        if tag not in self.tags:
            self.tags.append(tag)
