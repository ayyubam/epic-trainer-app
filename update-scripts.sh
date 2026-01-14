#!/bin/bash

# =================================================================
# EPIC EMR TRAINER ASSISTANT - UPDATE & MAINTENANCE SCRIPT
# Version: 1.0.0
# =================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[$(date '+%Y-%m-%d %H:%M:%S')]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Banner
print_banner() {
    echo -e "${GREEN}"
    echo "================================================================"
    echo "   EPIC EMR TRAINER ASSISTANT - UPDATE SCRIPT"
    echo "================================================================"
    echo -e "${NC}"
}

# Check dependencies
check_dependencies() {
    log "Checking dependencies..."
    
    local missing_deps=()
    
    # Check for required commands
    for cmd in curl git; do
        if ! command -v $cmd &> /dev/null; then
            missing_deps+=($cmd)
        fi
    done
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        warn "Missing dependencies: ${missing_deps[*]}"
        read -p "Install missing dependencies? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            if command -v apt-get &> /dev/null; then
                sudo apt-get update && sudo apt-get install -y ${missing_deps[@]}
            elif command -v yum &> /dev/null; then
                sudo yum install -y ${missing_deps[@]}
            elif command -v brew &> /dev/null; then
                brew install ${missing_deps[@]}
            else
                error "Package manager not found. Please install manually: ${missing_deps[*]}"
                exit 1
            fi
        fi
    fi
    
    log "Dependencies check complete"
}

# Backup current files
backup_files() {
    log "Creating backup of current files..."
    
    local backup_dir="backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    
    # Backup important files
    local files_to_backup=(
        "index.html"
        "styles.css"
        "app.js"
        "*.sh"
        "package.json"
        "package-lock.json"
    )
    
    for pattern in "${files_to_backup[@]}"; do
        if ls $pattern &> /dev/null; then
            cp -r $pattern "$backup_dir/" 2>/dev/null || true
        fi
    done
    
    # Backup directories
    if [ -d "assets" ]; then
        cp -r "assets" "$backup_dir/"
    fi
    
    if [ -d "images" ]; then
        cp -r "images" "$backup_dir/"
    fi
    
    log "Backup created: $backup_dir"
    echo "$backup_dir" > .last_backup
}

# Validate HTML structure
validate_html() {
    log "Validating HTML files..."
    
    if [ ! -f "index.html" ]; then
        error "index.html not found!"
        return 1
    fi
    
    # Check for basic HTML structure
    local errors=0
    
    # Check doctype
    if ! grep -q "<!DOCTYPE html>" "index.html"; then
        warn "Missing DOCTYPE declaration"
        ((errors++))
    fi
    
    # Check charset
    if ! grep -q "charset=UTF-8" "index.html"; then
        warn "Missing UTF-8 charset"
        ((errors++))
    fi
    
    # Check viewport
    if ! grep -q "viewport" "index.html"; then
        warn "Missing viewport meta tag"
        ((errors++))
    fi
    
    # Check for unclosed tags
    local open_tags=$(grep -o "<[^/][^>]*>" index.html | wc -l)
    local close_tags=$(grep -o "</[^>]*>" index.html | wc -l)
    
    if [ "$open_tags" -ne "$close_tags" ]; then
        warn "Possible unclosed tags: $open_tags opening vs $close_tags closing"
        ((errors++))
    fi
    
    # Check script placement
    local scripts_before_body=$(sed -n '/<body>/,/<\/body>/p' index.html | grep -c "<script>" || true)
    if [ "$scripts_before_body" -eq 0 ]; then
        warn "No scripts found in body - they should be at the bottom"
    fi
    
    if [ $errors -eq 0 ]; then
        log "HTML validation passed"
    else
        warn "HTML validation found $errors issue(s)"
    fi
}

# Minify CSS
minify_css() {
    log "Minifying CSS..."
    
    if [ ! -f "styles.css" ]; then
        warn "styles.css not found"
        return 1
    fi
    
    # Create minified version
    local minified="styles.min.css"
    
    # Remove comments, whitespace, and empty lines
    sed 's/\/\*.*\*\///g; s/\/\/.*//g' styles.css | \
    tr -d '\n' | \
    sed 's/  */ /g; s/:[ ]*/:/g; s/{[ ]*/{/g; s/;[ ]*/;/g; s/,[ ]*/,/g; s/}[ ]*/}/g' > "$minified"
    
    # Calculate savings
    local original_size=$(wc -c < styles.css)
    local minified_size=$(wc -c < "$minified")
    local savings=$((100 - (minified_size * 100 / original_size)))
    
    log "CSS minified: $minified (${savings}% smaller)"
}

# Bundle JavaScript files
bundle_js() {
    log "Bundling JavaScript files..."
    
    local bundle_file="bundle.js"
    local js_files=("app.js")
    
    # Check for additional JS files
    if [ -f "hospitals.js" ]; then
        js_files+=("hospitals.js")
    fi
    
    if [ -f "media.js" ]; then
        js_files+=("media.js")
    fi
    
    # Create bundle
    echo "// ===================================================================" > "$bundle_file"
    echo "// EPIC EMR TRAINER ASSISTANT - BUNDLED JAVASCRIPT" >> "$bundle_file"
    echo "// Generated: $(date)" >> "$bundle_file"
    echo "// ===================================================================" >> "$bundle_file"
    echo "" >> "$bundle_file"
    
    for js_file in "${js_files[@]}"; do
        if [ -f "$js_file" ]; then
            echo "// === FILE: $js_file ===" >> "$bundle_file"
            echo "" >> "$bundle_file"
            cat "$js_file" >> "$bundle_file"
            echo "" >> "$bundle_file"
            echo "// === END OF $js_file ===" >> "$bundle_file"
            echo "" >> "$bundle_file"
        fi
    done
    
    log "JavaScript bundled: $bundle_file"
    
    # Update HTML to use bundled file
    if [ -f "index.html" ]; then
        # Remove individual script tags
        sed -i.bak '/<script src=".*\.js"/d' index.html
        
        # Add bundled script at the end
        if ! grep -q "bundle.js" index.html; then
            sed -i '/<\/body>/i\    <script src="bundle.js"></script>' index.html
        fi
    fi
}

# Run basic tests
run_tests() {
    log "Running tests..."
    
    local passed=0
    local failed=0
    
    # Test 1: Check required files exist
    info "Test 1: Checking required files..."
    local required_files=("index.html" "app.js")
    
    for file in "${required_files[@]}"; do
        if [ -f "$file" ]; then
            log "  ✓ $file exists"
            ((passed++))
        else
            error "  ✗ $file missing"
            ((failed++))
        fi
    done
    
    # Test 2: Check JavaScript syntax
    info "Test 2: Checking JavaScript syntax..."
    if command -v node &> /dev/null; then
        if node -c app.js 2>/dev/null; then
            log "  ✓ app.js has valid syntax"
            ((passed++))
        else
            error "  ✗ app.js has syntax errors"
            ((failed++))
        fi
    else
        warn "  ⚠ Node.js not installed, skipping syntax check"
    fi
    
    # Test 3: Check HTML structure
    info "Test 3: Checking HTML structure..."
    if [ -f "index.html" ]; then
        if grep -q "<!DOCTYPE html>" "index.html" && \
           grep -q "<html" "index.html" && \
           grep -q "</html>" "index.html"; then
            log "  ✓ HTML structure is valid"
            ((passed++))
        else
            error "  ✗ HTML structure is invalid"
            ((failed++))
        fi
    fi
    
    # Test 4: Check for broken links
    info "Test 4: Checking for broken links..."
    if [ -f "index.html" ]; then
        local broken_links=0
        for link in $(grep -o 'href="[^"]*"' index.html | sed 's/href="//g; s/"//g'); do
            if [[ $link == http* ]]; then
                if ! curl -s --head "$link" | head -n 1 | grep -q "200\|301\|302"; then
                    warn "  ⚠ Broken external link: $link"
                    ((broken_links++))
                fi
            elif [ ! -f "$link" ] && [ ! -d "$link" ]; then
                warn "  ⚠ Broken local link: $link"
                ((broken_links++))
            fi
        done
        
        if [ $broken_links -eq 0 ]; then
            log "  ✓ No broken links found"
            ((passed++))
        else
            warn "  ⚠ Found $broken_links broken link(s)"
        fi
    fi
    
    # Summary
    info "Test Summary:"
    log "  Passed: $passed"
    if [ $failed -gt 0 ]; then
        error "  Failed: $failed"
    else
        log "  Failed: $failed"
    fi
}

# Clean up old files
cleanup() {
    log "Cleaning up..."
    
    # Remove old backups (keep last 7 days)
    find . -name "backup_*" -type d -mtime +7 -exec rm -rf {} \; 2>/dev/null || true
    
    # Remove temporary files
    rm -f *.tmp *.log *.bak 2>/dev/null || true
    
    # Remove node_modules if exists and not needed
    if [ -d "node_modules" ] && [ ! -f "package.json" ]; then
        warn "Removing unused node_modules..."
        rm -rf node_modules
    fi
    
    log "Cleanup complete"
}

# Update dependencies
update_dependencies() {
    log "Updating dependencies..."
    
    if [ -f "package.json" ]; then
        if command -v npm &> /dev/null; then
            npm update
            log "NPM dependencies updated"
        else
            warn "NPM not installed, skipping dependency update"
        fi
    else
        info "No package.json found, skipping dependency update"
    fi
}

# Deploy to Netlify
deploy_netlify() {
    log "Preparing for Netlify deployment..."
    
    if command -v netlify &> /dev/null; then
        read -p "Deploy to production? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            netlify deploy --prod
        else
            netlify deploy
        fi
    else
        warn "Netlify CLI not installed"
        info "To install: npm install -g netlify-cli"
    fi
}

# Restore from backup
restore_backup() {
    log "Available backups:"
    ls -d backup_* 2>/dev/null || warn "No backups found"
    
    read -p "Enter backup directory to restore: " backup_dir
    
    if [ -d "$backup_dir" ]; then
        read -p "This will overwrite current files. Continue? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            cp -r "$backup_dir"/* .
            log "Restored from $backup_dir"
        fi
    else
        error "Backup directory not found: $backup_dir"
    fi
}

# Interactive menu
show_menu() {
    clear
    print_banner
    
    echo "Select an option:"
    echo ""
    echo "  1) Check Dependencies"
    echo "  2) Backup Files"
    echo "  3) Validate HTML"
    echo "  4) Minify CSS"
    echo "  5) Bundle JavaScript"
    echo "  6) Run Tests"
    echo "  7) Update Dependencies"
    echo "  8) Cleanup Files"
    echo "  9) Deploy to Netlify"
    echo "  10) Restore from Backup"
    echo "  11) Run All Updates"
    echo "  0) Exit"
    echo ""
    
    read -p "Enter choice: " choice
    echo ""
    
    case $choice in
        1) check_dependencies ;;
        2) backup_files ;;
        3) validate_html ;;
        4) minify_css ;;
        5) bundle_js ;;
        6) run_tests ;;
        7) update_dependencies ;;
        8) cleanup ;;
        9) deploy_netlify ;;
        10) restore_backup ;;
        11)
            log "Running complete update sequence..."
            backup_files
            check_dependencies
            validate_html
            minify_css
            bundle_js
            run_tests
            update_dependencies
            cleanup
            log "All updates completed successfully!"
            ;;
        0)
            log "Goodbye!"
            exit 0
            ;;
        *)
            error "Invalid choice: $choice"
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
    show_menu
}

# Non-interactive mode
if [[ "$1" == "--non-interactive" ]] || [[ "$1" == "-n" ]]; then
    print_banner
    log "Running in non-interactive mode..."
    
    backup_files
    check_dependencies
    validate_html
    minify_css
    bundle_js
    run_tests
    update_dependencies
    cleanup
    
    log "All updates completed!"
    exit 0
fi

# Check for help
if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    print_banner
    echo "Usage: ./update-scripts.sh [OPTION]"
    echo ""
    echo "Options:"
    echo "  -n, --non-interactive  Run all updates without prompts"
    echo "  -h, --help             Show this help message"
    echo ""
    echo "Without options, runs interactive menu."
    exit 0
fi

# Start interactive menu
show_menu
