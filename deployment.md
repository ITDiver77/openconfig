# Deployment Procedure

## Universal Deployment Paradigm

All projects follow the same deployment pattern. The orchestrator reads this file to know how to deploy.

---

## Two Environments

Every project uses two Docker Compose environments — identical except for external ports:

| Environment | Compose File | Purpose | External Ports |
|-------------|-------------|---------|---------------|
| **Dev (TDD)** | `docker-compose.dev.yml` | TDD pipeline, tests run inside containers | 5-prefix (5443, 580, 58000) |
| **Production** | `docker-compose.yml` | Live deployment | Standard (443, 80, 8000) |

Both build from the **same Dockerfile**. Both use the **same internal Docker network ports**. Only external host port mapping differs.

---

## Port Mapping Rule

**Fixed rule:** prepend `5` to the beginning of every external port.

| Service Port | External (Dev) | Internal (unchanged) |
|-------------|---------------|---------------------|
| 443 | 5443 | 443 |
| 80 | 580 | 80 |
| 8000 | 58000 | 8000 |
| 5432 | 55432 | 5432 |
| 6379 | 56379 | 6379 |
| 3000 | 53000 | 3000 |

Internal Docker network ports never change — services communicate on original ports inside the network.

---

## Nginx Coexistence

Dev and production nginx run simultaneously without conflict:

| Nginx | HTTP | HTTPS | Runs in |
|-------|------|-------|---------|
| Production | 80 | 443 | System or prod container |
| Dev | 580 | 5443 | Dev container only |

If port conflicts occur:
1. `sudo lsof -i :<port>` to identify what's bound
2. Dev ports should only be bound by dev Docker container
3. Prod ports should only be bound by system nginx
4. **If in doubt, ask the user**

---

## Dev Environment (TDD)

### docker-compose.dev.yml Template

```yaml
services:
  app:
    build:
      context: ..
      dockerfile: Dockerfile
    ports:
      - "58000:8000"
    environment:
      - ENV=dev

  nginx:
    image: nginx:alpine
    ports:
      - "580:80"
      - "5443:443"

  db:
    image: postgres:16
    ports:
      - "55432:5432"
```

### Lifecycle

```
Before Phase 1:  Build dev → start → wait for ready
Phase 1 (RED):   Tester writes tests → run in dev → FAIL (no impl yet)
Phase 2 (GREEN): Developer implements → run tests in dev → PASS
Phase 3 (VALID): Run all tests + edge cases in dev
Phase 5 (COMMIT): Tear down dev → commit
```

### Commands

```bash
docker compose -f docker-compose.dev.yml build --no-cache
docker compose -f docker-compose.dev.yml up -d
sleep 5
docker compose -f docker-compose.dev.yml exec app pytest -v
docker compose -f docker-compose.dev.yml exec app npm test
docker compose -f docker-compose.dev.yml down
```

**Always tear down dev before committing.**

---

## Production Deployment

Deploy ONLY when all tasks in todo.md are done.

### Step 1: Pre-Deploy CI

```bash
# Tear down dev
docker compose -f docker-compose.dev.yml down 2>/dev/null

# Lint
ruff check .                  # Python
biome check .                 # JS/TS

# Format
ruff format --check .         # Python
biome check .                 # JS/TS

# Type check
mypy .                        # Python
tsc --noEmit                  # JS/TS

# Final test run in dev
docker compose -f docker-compose.dev.yml build --no-cache
docker compose -f docker-compose.dev.yml up -d
sleep 5
docker compose -f docker-compose.dev.yml exec app pytest -v
docker compose -f docker-compose.dev.yml down
```

If ANY step fails — do NOT deploy. Report failure to user.

### Step 2: Build and Deploy

```bash
# Build production (no cache)
docker compose build --no-cache

# Start production
docker compose up -d

# Wait
sleep 5
```

### Step 3: Health Check

```bash
docker compose ps
docker compose logs --tail=50
curl -f http://localhost:8000/health || echo "HEALTH CHECK FAILED"
```

Success: all containers "Up", no errors in logs, health endpoint 200.

### Rollback

```bash
docker compose logs --tail=100
docker compose down
docker compose rm -f
```

**Do NOT automatically rollback.** Report error and wait for user instruction.

---

## Reporting

```
Deployment SUCCESSFUL / FAILED.
- Containers: <N> running / <which failed>
- Health check: PASSED / FAILED
- URL: <url>
- Error (if any): <message>
- Logs: <relevant output>
- Action needed: <what user should do>
```
