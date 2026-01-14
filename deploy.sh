#!/bin/bash

# =================================================================
# EPIC EMR TRAINER ASSISTANT - DEPLOYMENT SCRIPT
# Version: 1.0.0
# =================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging
log() { echo -e "${GREEN}[DEPLOY]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }
info() { echo -e "${BLUE}[INFO]${NC} $1"; }

# Banner
print_banner() {
    echo -e "${GREEN}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║          EPIC EMR TRAINER DEPLOYMENT                    ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Check if running in correct directory
check_directory() {
    log "Checking project structure..."
    
    local required_files=("index.html" "app.js")
    local missing_files=()
    
    for file in "${required_files[@]}"; do
        if [ ! -f "$file" ]; then
            missing_files+=("$file")
        fi
    done
    
    if [ ${#missing_files[@]} -gt 0 ]; then
        error "Missing required files: ${missing_files[*]}"
        error "Please run from the project root directory"
        exit 1
    fi
    
    log "✓ Project structure OK"
}

# Create build directory
create_build() {
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local build_dir="build_$timestamp"
    
    log "Creating build directory: $build_dir"
    
    mkdir -p "$build_dir"
    
    # Copy HTML file
    cp index.html "$build_dir/"
    
    # Copy CSS
    if [ -f "styles.css" ]; then
        cp styles.css "$build_dir/"
    fi
    
    if [ -f "styles.min.css" ]; then
        cp styles.min.css "$build_dir/"
    fi
    
    # Copy JavaScript
    if [ -f "bundle.js" ]; then
        cp bundle.js "$build_dir/"
    else
        cp app.js "$build_dir/"
        # Copy other JS files if they exist
        for js_file in hospitals.js media.js; do
            if [ -f "$js_file" ]; then
                cp "$js_file" "$build_dir/"
            fi
        done
    fi
    
    # Copy assets
    if [ -d "assets" ]; then
        cp -r assets "$build_dir/"
    fi
    
    if [ -d "images" ]; then
        cp -r images "$build_dir/"
    fi
    
    # Copy configuration files
    for config_file in netlify.toml _redirects _headers; do
        if [ -f "$config_file" ]; then
            cp "$config_file" "$build_dir/"
        fi
    done
    
    # Create README for build
    cat > "$build_dir/README.md" << EOF
# Epic EMR Trainer Assistant Build
- Build Date: $(date)
- Version: 1.0.0
- Deployment ready

## Files included:
$(find . -maxdepth 1 -type f -name "*.html" -o -name "*.css" -o -name "*.js" | sed 's/^/- /')
