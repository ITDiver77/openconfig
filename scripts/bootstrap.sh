#!/bin/bash
set -e

STATEFUL=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --stateful)
            STATEFUL=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--stateful]"
            exit 1
            ;;
    esac
done

SCRIPTS_DIR="$(pwd)/scripts"

if [ ! -d "${SCRIPTS_DIR}" ]; then
    mkdir -p "${SCRIPTS_DIR}"
fi

cat > "${SCRIPTS_DIR}/setup-dev.sh" << 'SCRIPT_EOF'
#!/bin/bash
set -e

echo "Running development environment setup..."

# Detect project type
if [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
    echo "Detected Python project..."
    
    # Check for virtual environment
    if [ ! -d "venv" ] && [ ! -d ".venv" ]; then
        echo "Creating virtual environment..."
        python3 -m venv venv
    fi
    
    echo "Activating virtual environment..."
    source venv/bin/activate
    
    echo "Installing dependencies..."
    if [ -f "requirements.txt" ]; then
        pip install -r requirements.txt
    elif [ -f "requirements-dev.txt" ]; then
        pip install -r requirements-dev.txt
    else
        pip install -e ".[dev]"
    fi
fi

if [ -f "package.json" ]; then
    echo "Detected Node.js project..."
    
    if [ ! -d "node_modules" ]; then
        echo "Installing dependencies..."
        npm install
    fi
fi

if [ -f "docker-compose.yml" ] || [ -f "docker-compose.yaml" ]; then
    echo "Detecting Docker Compose services..."
    
    echo "Starting services..."
    docker-compose up -d
    
    echo "Waiting for services to be ready..."
    sleep 5
    
    # Add service-specific health checks here
    # Example:
    # until docker-compose exec -T db pg_isready; do sleep 1; done
fi

# Run database migrations
if [ -f "manage.py" ]; then
    echo "Running migrations..."
    python manage.py migrate
elif [ -d "migrations" ]; then
    echo "Running Alembic migrations..."
    alembic upgrade head
fi

echo "✓ Development environment ready!"
SCRIPT_EOF

if [ "$STATEFUL" = true ]; then
    cat >> "${SCRIPTS_DIR}/setup-dev.sh" << 'STATEFUL_EOF'

# Stateful project specific setup
echo "Running stateful services setup..."

# Add your stateful service setup here
# Example:
# - Start database containers
# - Run migrations
# - Seed initial data
# - Start background workers

STATEFUL_EOF
fi

chmod +x "${SCRIPTS_DIR}/setup-dev.sh"

echo ""
echo "✓ Created scripts/setup-dev.sh"
echo ""
echo "Edit the script to customize your setup."
echo ""
echo "For stateless projects, the script will:"
echo "  - Create/activate virtual environment"
echo "  - Install Python dependencies"
echo "  - Install npm dependencies"
echo ""
echo "For stateful projects, add:"
echo "  - Database migrations"
echo "  - Docker services"
echo "  - Background workers"
echo "  - Health checks"
