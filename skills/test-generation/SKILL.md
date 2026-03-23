---
name: test-generation
description: Generate comprehensive unit tests with proper structure
---

# Test Generation Guidelines

## Session Start Protocol

**FIRST:** Read these files at the start of EVERY session:
1. `project.md` - Full project overview
2. `todo.md` - Current tasks and plans
3. `context.md` - Important patterns and decisions
4. `changelog.md` - Recent changes in previous sessions

## Test Structure

### One Test File Per Module

```
src/
├── services/
│   └── auth.py
tests/
├── test_services/
│   ├── __init__.py
│   └── test_auth.py    # One file per service
```

### Test Naming Convention

```python
def test_<function>_<scenario>_<expected_result>():
    """Clear description of what is being tested."""
    ...

# Examples:
def test_calculate_total_with_valid_items_returns_correct_sum():
    ...

def test_login_with_invalid_password_raises_error():
    ...

def test_get_user_by_id_when_user_not_found_returns_none():
    ...
```

### Test Organization

```python
import pytest
from unittest.mock import Mock, AsyncMock, patch

class TestUserService:
    """Tests for UserService class."""
    
    @pytest.fixture
    def user_service(self):
        """Create service instance with mocked dependencies."""
        return UserService(user_repo=Mock(), cache=Mock())
    
    # Group by method
    class TestGetUser:
        """Tests for get_user method."""
        
        def test_returns_user_when_found(self, user_service):
            ...
        
        def test_returns_none_when_not_found(self, user_service):
            ...
    
    class TestCreateUser:
        """Tests for create_user method."""
        
        async def test_creates_user_with_valid_data(self, user_service):
            ...
        
        async def test_raises_error_for_duplicate_email(self, user_service):
            ...
```

## Coverage Requirements

### Happy Path
- [ ] Normal case with valid input
- [ ] Typical usage scenario

### Edge Cases
- [ ] Empty input
- [ ] Null/None values
- [ ] Boundary values
- [ ] Maximum values
- [ ] Minimum values
- [ ] Single item collections
- [ ] Very large collections

### Error Cases
- [ ] Invalid input types
- [ ] Missing required fields
- [ ] External service failures
- [ ] Network timeouts
- [ ] Permission denied
- [ ] Resource not found
- [ ] Concurrent access

## Fixtures

### Shared Fixtures (conftest.py)

```python
import pytest
from unittest.mock import Mock
from src.app import Application
from src.models import User, Order

@pytest.fixture
def app():
    """Create application instance for testing."""
    return Application(config=TestConfig())

@pytest.fixture
def mock_user():
    """Create a mock user."""
    return User(
        id=1,
        email="test@example.com",
        name="Test User"
    )

@pytest.fixture
def mock_db():
    """Create mocked database session."""
    db = Mock()
    db.query.return_value = Mock()
    return db

@pytest.fixture(autouse=True)
def reset_environment():
    """Reset environment between tests."""
    # Setup
    yield
    # Teardown
```

### Test-Specific Fixtures

```python
@pytest.fixture
def user_with_orders(mock_user):
    """User with associated orders."""
    mock_user.orders = [
        Order(id=1, total=100.0),
        Order(id=2, total=50.0)
    ]
    return mock_user

@pytest.fixture
def expired_token():
    """Generate expired JWT token."""
    return jwt.encode(
        {"exp": datetime.utcnow() - timedelta(hours=1)},
        key="secret"
    )
```

## Assertions

### Be Specific

```python
# ❌ INCORRECT
assert result == expected

# ✅ CORRECT
assert result.status_code == 200
assert result.body["id"] == 1
assert result.body["email"] == "test@example.com"
```

### Descriptive Messages

```python
# ❌ INCORRECT
assert user

# ✅ CORRECT
assert user is not None, "User should be created"
assert user.id == 1, f"Expected user ID 1, got {user.id}"
```

### Multiple Related Assertions

```python
# ✅ CORRECT - Group related assertions
def test_user_properties_are_correct(mock_user):
    """User should have correct properties."""
    assert mock_user.id == 1
    assert mock_user.email == "test@example.com"
    assert mock_user.name == "Test User"
    assert mock_user.is_active is True
```

## Async Tests

```python
import pytest
import pytest.mark.asyncio

class TestAsyncService:
    @pytest.mark.asyncio
    async def test_fetch_user_returns_user(self):
        """Should return user when found."""
        service = AsyncUserService(mock_repo)
        mock_repo.find_by_id.return_value = User(id=1)
        
        result = await service.fetch_user(1)
        
        assert result.id == 1
        mock_repo.find_by_id.assert_called_once_with(1)
    
    @pytest.mark.asyncio
    async def test_fetch_user_raises_when_not_found(self):
        """Should raise UserNotFoundError."""
        service = AsyncUserService(mock_repo)
        mock_repo.find_by_id.return_value = None
        
        with pytest.raises(UserNotFoundError) as exc_info:
            await service.fetch_user(999)
        
        assert "999" in str(exc_info.value)
```

## Mocking

### Mock External Dependencies

```python
# ✅ CORRECT
from unittest.mock import Mock, patch

def test_sends_email_on_registration(mock_smtp):
    """Should send welcome email after registration."""
    user_service = UserService(email_service=mock_smtp)
    
    user_service.register(email="test@example.com")
    
    mock_smtp.send.assert_called_once()
    call_args = mock_smtp.send.call_args
    assert "welcome" in call_args[0][0].lower()

# ✅ CORRECT - Patch at module level
@patch("src.services.email.send_email")
def test_email_sent(mock_send):
    """Email should be sent."""
    ...
```

### Mocking Database

```python
def test_creates_user_in_database(mock_db):
    """Should create user and commit transaction."""
    mock_db.query.return_value.first.return_value = None
    mock_session = Mock()
    mock_session.query.return_value = mock_db.query
    
    service = UserService(session=mock_session)
    user = service.create(email="test@example.com")
    
    mock_session.add.assert_called_once()
    mock_session.commit.assert_called_once()
```

## Test Data Factories

```python
import factory
from src.models import User

class UserFactory(factory.Factory):
    class Meta:
        model = User
    
    id = factory.Sequence(lambda n: n)
    email = factory.LazyAttribute(lambda obj: f"user{n}@example.com")
    name = factory.Faker("name")
    is_active = True

# Usage
user = UserFactory()
admin = UserFactory(email="admin@example.com")
```

## Common Patterns

### Testing Exceptions

```python
def test_raises_value_error_for_invalid_input():
    """Should raise ValueError for negative numbers."""
    with pytest.raises(ValueError) as exc_info:
        calculator.sqrt(-1)
    
    assert "negative" in str(exc_info.value).lower()
```

### Testing Time-Dependent Code

```python
def test_token_expiry():
    """Token should expire after 24 hours."""
    with freeze_time("2024-01-01 12:00:00"):
        token = create_token()
        assert token.is_valid() is True
    
    with freeze_time("2024-01-02 12:00:01"):
        assert token.is_valid() is False
```

### Testing API Endpoints

```python
import pytest
from fastapi.testclient import TestClient

def test_create_user_endpoint(test_client):
    """POST /users should create user."""
    response = test_client.post(
        "/users",
        json={"email": "new@example.com", "name": "New User"}
    )
    
    assert response.status_code == 201
    data = response.json()
    assert data["email"] == "new@example.com"
    assert "id" in data
```

## Coverage Report

After running tests:

```bash
pytest --cov=src --cov-report=term-missing --cov-report=html
```

Check for:
- Lines not covered
- Branches not tested
- Functions without tests
