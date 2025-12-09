#!/bin/bash
# Google Search Console + Claude Code Setup Script
# Automates initial setup and configuration

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CREDENTIALS_DIR="$HOME/.gsc-credentials"
VENV_DIR=".venv"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}Google Search Console + Claude Code Setup${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}\n"

# Function to print step
print_step() {
    echo -e "${BLUE}[Step]${NC} $1"
}

# Function to print success
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

# Function to print warning
print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Function to print error
print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check prerequisites
print_step "Checking prerequisites..."

if ! command -v python3 &> /dev/null; then
    print_error "Python 3 not found. Please install Python 3.8 or higher."
    exit 1
fi
print_success "Python 3 found: $(python3 --version)"

if ! command -v git &> /dev/null; then
    print_error "Git not found. Please install Git."
    exit 1
fi
print_success "Git found"

# Create credentials directory
print_step "Setting up credentials directory..."
mkdir -p "$CREDENTIALS_DIR"
chmod 700 "$CREDENTIALS_DIR"
print_success "Credentials directory created at: $CREDENTIALS_DIR"

# Check for service account key
print_step "Looking for service account key..."
if [ -f "$CREDENTIALS_DIR/service-account-key.json" ]; then
    print_success "Service account key found"
    SERVICE_KEY_PATH="$CREDENTIALS_DIR/service-account-key.json"
else
    print_warning "Service account key not found at $CREDENTIALS_DIR/service-account-key.json"
    echo -e "\n${YELLOW}Please provide the path to your service account JSON key:${NC}"
    read -p "Path to service-account-key.json: " SERVICE_KEY_PATH

    if [ ! -f "$SERVICE_KEY_PATH" ]; then
        print_error "File not found: $SERVICE_KEY_PATH"
        exit 1
    fi

    # Copy to secure location
    cp "$SERVICE_KEY_PATH" "$CREDENTIALS_DIR/service-account-key.json"
    chmod 600 "$CREDENTIALS_DIR/service-account-key.json"
    print_success "Key copied to $CREDENTIALS_DIR/service-account-key.json"
    SERVICE_KEY_PATH="$CREDENTIALS_DIR/service-account-key.json"
fi

# Create Python virtual environment
print_step "Creating Python virtual environment..."
if [ -d "$VENV_DIR" ]; then
    print_warning "Virtual environment already exists"
else
    python3 -m venv "$VENV_DIR"
    print_success "Virtual environment created"
fi

# Activate virtual environment
print_step "Activating virtual environment..."
source "$VENV_DIR/bin/activate"
print_success "Virtual environment activated"

# Install dependencies
print_step "Installing Python dependencies..."
pip install --quiet --upgrade pip setuptools wheel
pip install --quiet google-auth-oauthlib google-auth-httplib2 google-api-python-client

print_success "Dependencies installed"

# Test connection
print_step "Testing GSC connection..."
if python3 test_gsc_connection.py --key-path "$SERVICE_KEY_PATH"; then
    print_success "GSC connection test passed"
else
    print_error "GSC connection test failed. Please check your credentials."
    exit 1
fi

# Get system info for Claude config
print_step "Gathering configuration information..."
PYTHON_PATH="$(which python)"
MCP_SERVER_PATH="$(pwd)/gsc_server.py"

if [ ! -f "$MCP_SERVER_PATH" ]; then
    print_warning "MCP server script not found at $MCP_SERVER_PATH"
    print_warning "You may need to clone the mcp-gsc repository"
    echo ""
    echo "To use this setup with Claude Code, clone the mcp-gsc repository:"
    echo "  git clone https://github.com/AminForou/mcp-gsc.git"
    echo "  cd mcp-gsc"
    echo "  bash ../setup_gsc_claude.sh"
    echo ""
fi

# Display Claude configuration
print_step "Claude Configuration"
echo ""
echo -e "${YELLOW}Add the following to your Claude config file:${NC}"
echo ""

if [[ "$OSTYPE" == "darwin"* ]]; then
    CONFIG_PATH="$HOME/Library/Application Support/Claude/claude_desktop_config.json"
else
    CONFIG_PATH="$HOME/.config/claude/claude_desktop_config.json"
fi

echo "Config file location: $CONFIG_PATH"
echo ""
echo "Add this JSON snippet:"
echo "{"
echo "  \"mcpServers\": {"
echo "    \"gsc\": {"
echo "      \"command\": \"$PYTHON_PATH\","
echo "      \"args\": [\"$MCP_SERVER_PATH\"],"
echo "      \"env\": {"
echo "        \"GSC_CREDENTIALS_PATH\": \"$SERVICE_KEY_PATH\""
echo "      }"
echo "    }"
echo "  }"
echo "}"
echo ""

# Create config snippet file for easy copy
CONFIG_SNIPPET="$CREDENTIALS_DIR/claude-config-snippet.json"
cat > "$CONFIG_SNIPPET" << EOF
{
  "mcpServers": {
    "gsc": {
      "command": "$PYTHON_PATH",
      "args": ["$MCP_SERVER_PATH"],
      "env": {
        "GSC_CREDENTIALS_PATH": "$SERVICE_KEY_PATH"
      }
    }
  }
}
EOF

print_success "Configuration snippet saved to: $CONFIG_SNIPPET"

# Summary
echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}Setup Complete!${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════${NC}\n"

echo "Next steps:"
echo "1. Edit your Claude Desktop config file: $CONFIG_PATH"
echo "2. Add the MCP server configuration (see above)"
echo "3. Restart Claude Desktop"
echo "4. Test with a natural language query in Claude"
echo ""
echo "For more details, see: GSC_CLAUDE_SOP.md"
echo ""

deactivate 2>/dev/null || true
