# Python Development Agent

## Session Start Protocol

**FIRST:** Read these files at the start of EVERY session:
1. `product.md` - Full project overview
2. `todo.md` - Current tasks and plans
3. `context.md` - Important patterns and decisions
4. `changelog.md` - Recent changes in previous sessions

Then:
- Detect project type (stateless vs stateful)
- Verify setup-dev.sh if project is stateful

## Core Practices

### Project Structure (src/ Layout)

```
src/
├── __init__.py
├── main.py
├── config.py
├── models/
│   ├── __init__.py
│   ├── user.py
│   └── base.py
├── services/
│   ├── __init__.py
│   ├── auth.py
│   └── user_service.py
├── utils/
│   ├── __init__.py
│   ├── helpers.py
│   └── validators.py
└── api/
    ├── __init__.py
    ├── routes.py
    └── dependencies.py

tests/
├── __init__.py
├── conftest.py
├── fixtures/
│   └── __init__.py
├── test_models/
│   ├── __init__.py
│   └── test_user.py
├── test_services/
│   ├── __init__.py
│   └── test_auth.py
└── test_utils/
    ├── __init__.py
    └── test_helpers.py
```

### Type Hints (MANDATORY)

All function signatures MUST have type hints for parameters AND return types.

```python
# ✅ CORRECT
def calculate_total(items: List[Item], tax: float) -> float:
    """Calculate total price including tax."""
    ...

def get_user_by_id(user_id: int) -> Optional[User]:
    """Get user by ID or None if not found."""
    ...

def process_batch(items: List[Dict[str, Any]]) -> Tuple[bool, List[str]]:
    """Process items and return success status and errors."""
    ...

# ❌ INCORRECT
def calculate_total(items, tax):
    ...
```

**Collections:** Use explicit types for cross-version compatibility:
- `List[X]` instead of `list[X]` (unless py310+)
- `Dict[K, V]` instead of `dict[K, V]`
- `Tuple[X, Y]` instead of `tuple[X, Y]`

**Optional types:**
- `Optional[X]` (preferred for py39+)
- `X | None` (only for py310+)

**Protocol for interfaces:**
```python
from typing import Protocol, runtime_checkable

@runtime_checkable
class CacheBackend(Protocol):
    def get(self, key: str) -> Optional[Any]: ...
    def set(self, key: str, value: Any, ttl: int = 3600) -> None: ...
    def delete(self, key: str) -> None: ...
```

### Docstrings (Google Style)

```python
def calculate_total(items: List[Item], tax: float) -> float:
    """Calculate total price including tax.
    
    Args:
        items: List of items to sum. Each item must have a 'price' attribute.
        tax: Tax rate as decimal (e.g., 0.08 for 8%)
    
    Returns:
        Total price including tax, rounded to 2 decimal places.
    
    Raises:
        ValueError: If items list is empty.
        TypeError: If items contain non-numeric prices.
    
    Example:
        >>> items = [Item(price=10.0), Item(price=20.0)]
        >>> calculate_total(items, 0.1)
        33.0
    """
    if not items:
        raise ValueError("Items list cannot be empty")
    subtotal = sum(item.price for item in items)
    return round(subtotal * (1 + tax), 2)
```

### Error Handling

```python
# ✅ CORRECT
try:
    result = await fetch_user(user_id)
except UserNotFoundError as e:
    logger.warning(f"User not found: {user_id}")
    raise UserNotFoundError(f"User {user_id} does not exist") from e
except DatabaseError as e:
    logger.error(f"Database error fetching user: {e}")
    raise

# ❌ INCORRECT
try:
    result = fetch_user(user_id)
except:
    pass  # Silent failure

# ❌ INCORRECT  
except Exception:
    print("error")  # No logging, no re-raise
```

**Rules:**
1. Catch specific exceptions, never bare `except:`
2. Always log errors with context
3. Re-raise with exception chaining (`from e`)
4. Never swallow exceptions silently
5. Add context in error messages

### Testing (pytest)

**Test File Structure:**
```python
# tests/test_services/test_auth.py
import pytest
from unittest.mock import Mock, AsyncMock
from src.services.auth import AuthService, InvalidCredentialsError

class TestAuthService:
    """Tests for AuthService."""
    
    @pytest.fixture
    def auth_service(self):
        """Create AuthService instance for testing."""
        return AuthService(user_repo=Mock(), token_service=Mock())
    
    @pytest.fixture
    def valid_user(self):
        """Create a valid user for testing."""
        return User(id=1, email="test@example.com", password_hash="hashed")
    
    @pytest.mark.asyncio
    async def test_login_with_valid_credentials_returns_token(
        self, auth_service, valid_user
    ):
        """Should return access token when credentials are valid."""
        auth_service.user_repo.find_by_email.return_value = valid_user
        auth_service.token_service.create.return_value = "jwt_token"
        
        result = await auth_service.login("test@example.com", "password123")
        
        assert result.access_token == "jwt_token"
        assert result.token_type == "Bearer"
        auth_service.user_repo.find_by_email.assert_called_once_with("test@example.com")
    
    @pytest.mark.asyncio
    async def test_login_with_invalid_password_raises_error(
        self, auth_service, valid_user
    ):
        """Should raise InvalidCredentialsError when password is wrong."""
        auth_service.user_repo.find_by_email.return_value = valid_user
        auth_service.token_service.verify_password.return_value = False
        
        with pytest.raises(InvalidCredentialsError) as exc_info:
            await auth_service.login("test@example.com", "wrong_password")
        
        assert "Invalid credentials" in str(exc_info.value)
```

**Naming Convention:**
- `test_<module>_<function>_<scenario>_<expected>`
- Use descriptive names: `test_should_return_empty_list_when_no_users`
- Avoid: `test_login`, `test_user`

**Test Organization:**
1. One assertion per test when practical (or few related assertions)
2. Group tests by method/class
3. Use descriptive class names: `TestUserService`
4. Shared fixtures in `conftest.py`

### Imports (isort)

```python
# 1. Standard library
import os
import sys
from typing import List, Optional, Dict, Tuple, Any
from dataclasses import dataclass, field
from datetime import datetime
import asyncio

# 2. Third party
from fastapi import FastAPI, Depends, HTTPException
from pydantic import BaseModel, EmailStr, validator
from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import Session
import pytest

# 3. Local (absolute)
from src.models.user import User
from src.utils.helpers import format_date, validate_email

# 4. Local (relative)
from .base import BaseModel
from ..services.auth import AuthService
```

### Git Commits

**Format:**
```
feat: add user authentication via JWT

Implemented JWT-based authentication with refresh tokens to improve security.

Changes:
- Added PyJWT dependency for token handling
- Created AuthService with login/logout methods
- Implemented token refresh with 7-day expiry
- Added /auth/login and /auth/refresh endpoints

Before: All endpoints were public, no authentication
After: Protected endpoints require valid JWT, refresh supported

Security:
- Tokens expire in 24 hours
- Refresh tokens valid for 7 days
- Passwords hashed with bcrypt

Closes #123
```

**Never commit:**
- `print()` statements for debugging
- Commented-out code
- `# TODO: fix later` placeholders
- API keys, passwords, secrets
- Generated files (node_modules, __pycache__, etc.)

## Quality Gates

Before ANY commit:

```bash
# 1. Lint
ruff check .

# 2. Format
ruff format .

# 3. Typecheck
mypy .

# 4. Tests
pytest -v --cov=src --cov-report=term-missing
```

## Configuration Files

### ruff.toml
Located in `configs/python/ruff.toml`

### mypy.ini
Located in `configs/python/mypy.ini`

### pyproject.toml
Located in `configs/python/pyproject.toml`

## Key Commands

| Command | Purpose |
|---------|---------|
| `ruff check .` | Lint Python files |
| `ruff format .` | Format Python files |
| `mypy .` | Type check Python files |
| `pytest -v` | Run tests |
| `pytest --cov=src` | Run with coverage |

## Best Practices Summary

1. **Always use type hints** - Parameters and return types
2. **Follow src/ layout** - Keep source separate from tests
3. **Write descriptive tests** - One clear assertion per test
4. **Handle errors specifically** - Never catch everything
5. **Log with context** - Include relevant data
6. **Commit atomically** - One change per commit
7. **Document the why** - Explain decisions in commit messages
