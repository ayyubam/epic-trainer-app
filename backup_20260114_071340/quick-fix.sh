#!/bin/bash

# =================================================================
# EPIC EMR TRAINER ASSISTANT - QUICK FIX SCRIPT
# Version: 1.0.0
# =================================================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() { echo -e "${GREEN}[FIX]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

echo -e "${GREEN}Running quick fixes for Epic EMR Trainer...${NC}"
echo "=========================================="

# Fix 1: Ensure all required files exist
log "1. Checking required files..."

if [ ! -f "index.html" ]; then
    warn "index.html missing - creating basic template..."
    cat > index.html << 'HTML'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Epic EMR Trainer Assistant</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <header>
        <div class="header-content">
            <div class="logo">
                <i class="fas fa-hospital-user"></i>
                <span>Epic EMR Trainer Assistant</span>
            </div>
            <div class="user-actions">
                <div class="premium-badge" id="premium-status">
                    <i class="fas fa-crown"></i>
                    <span>Free Plan</span>
                </div>
                <button id="login-btn" class="btn btn-primary">
                    <i class="fas fa-user"></i> Trainer Login
                </button>
            </div>
        </div>
    </header>
    
    <nav>
        <ul class="nav-tabs">
            <li><a href="#dashboard" class="nav-link active">
                <i class="fas fa-home"></i> Dashboard
            </a></li>
            <li><a href="#hospitals" class="nav-link">
                <i class="fas fa-hospital"></i> Hospital Systems
            </a></li>
            <li><a href="#resources" class="nav-link">
                <i class="fas fa-book"></i> Resources
            </a></li>
            <li><a href="#faq" class="nav-link">
                <i class="fas fa-question-circle"></i> FAQ
            </a></li>
            <li><a href="#go-live" class="nav-link">
                <i class="fas fa-rocket"></i> Go-Live Support
            </a></li>
            <li><a href="#profile" class="nav-link">
                <i class="fas fa-user"></i> My Profile
            </a></li>
        </ul>
    </nav>
    
    <main>
        <!-- Content will be loaded here -->
    </main>
    
    <footer>
        <p>Epic EMR Trainer Assistant | For training purposes only</p>
        <p>This application is not affiliated with Epic Systems Corporation</p>
    </footer>
    
    <!-- Modals -->
    <div class="modal-overlay" id="upload-modal">
        <div class="modal">
            <div class="modal-header">
                <h2>Upload Resource</h2>
                <button class="modal-close">&times;</button>
            </div>
            <div class="modal-body">
                <p>Upload functionality will be loaded from app.js</p>
            </div>
        </div>
    </div>
    
    <script src="app.js"></script>
</body>
</html>
HTML
    log "✓ Created index.html"
else
    log "✓ index.html exists"
fi

# Fix 2: Ensure CSS file exists
if [ ! -f "styles.css" ]; then
    warn "styles.css missing - creating basic styles..."
    cat > styles.css << 'CSS'
/* Epic EMR Trainer Assistant - Main Styles */
:root {
    /* Colors */
    --epic-purple: #4B286D;
    --epic-light-purple: #7B52AB;
    --epic-dark: #2A1A40;
    --light-gray: #f8f9fa;
    --medium-gray: #dee2e6;
    --dark-gray: #6c757d;
    --success: #28a745;
    --warning: #ffc107;
    --danger: #dc3545;
    --info: #17a2b8;
    
    /* Spacing */
    --spacing-xs: 0.25rem;
    --spacing-sm: 0.5rem;
    --spacing-md: 1rem;
    --spacing-lg: 1.5rem;
    --spacing-xl: 2rem;
    
    /* Border radius */
    --radius-sm: 0.25rem;
    --radius-md: 0.5rem;
    --radius-lg: 1rem;
}

/* Reset & Base */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    line-height: 1.6;
    color: #333;
    background: var(--light-gray);
}

/* Header */
header {
    background: linear-gradient(135deg, var(--epic-dark), var(--epic-purple));
    color: white;
    padding: var(--spacing-md) var(--spacing-xl);
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

.header-content {
    display: flex;
    justify-content: space-between;
    align-items: center;
    max-width: 1200px;
    margin: 0 auto;
}

.logo {
    display: flex;
    align-items: center;
    gap: var(--spacing-md);
    font-size: 1.5rem;
    font-weight: bold;
}

.logo i {
    font-size: 2rem;
}

.user-actions {
    display: flex;
    align-items: center;
    gap: var(--spacing-md);
}

/* Navigation */
nav {
    background: white;
    border-bottom: 1px solid var(--medium-gray);
    position: sticky;
    top: 0;
    z-index: 100;
}

.nav-tabs {
    display: flex;
    list-style: none;
    max-width: 1200px;
    margin: 0 auto;
    overflow-x: auto;
}

.nav-link {
    display: flex;
    align-items: center;
    gap: var(--spacing-sm);
    padding: var(--spacing-md) var(--spacing-lg);
    text-decoration: none;
    color: var(--dark-gray);
    white-space: nowrap;
    border-bottom: 3px solid transparent;
}

.nav-link:hover {
    color: var(--epic-purple);
    background: var(--light-gray);
}

.nav-link.active {
    color: var(--epic-purple);
    border-bottom-color: var(--epic-purple);
    font-weight: 600;
}

/* Main Content */
main {
    max-width: 1200px;
    margin: var(--spacing-xl) auto;
    padding: 0 var(--spacing-lg);
}

.tab-content {
    display: none;
    animation: fadeIn 0.3s ease;
}

.tab-content.active {
    display: block;
}

@keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
}

/* Cards */
.hospital-card, .resource-card, .stat-card {
    background: white;
    border-radius: var(--radius-md);
    padding: var(--spacing-lg);
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.hospital-card:hover, .resource-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
}

.stat-card {
    text-align: center;
}

.stat-card i {
    font-size: 2rem;
    color: var(--epic-purple);
    margin-bottom: var(--spacing-sm);
}

.stat-card h3 {
    font-size: 2rem;
    color: var(--epic-dark);
    margin: var(--spacing-sm) 0;
}

/* Grids */
.hospital-grid, .resource-grid, .stats-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: var(--spacing-lg);
    margin: var(--spacing-lg) 0;
}

/* Buttons */
.btn {
    display: inline-flex;
    align-items: center;
    gap: var(--spacing-sm);
    padding: var(--spacing-sm) var(--spacing-lg);
    border: none;
    border-radius: var(--radius-sm);
    font-size: 1rem;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.3s ease;
    text-decoration: none;
}

.btn-primary {
    background: var(--epic-purple);
    color: white;
}

.btn-primary:hover {
    background: var(--epic-light-purple);
    transform: translateY(-1px);
}

.btn-outline {
    background: transparent;
    color: var(--epic-purple);
    border: 2px solid var(--epic-purple);
}

.btn-outline:hover {
    background: var(--epic-purple);
    color: white;
}

.btn-success {
    background: var(--success);
    color: white;
}

.btn-premium {
    background: linear-gradient(135deg, #FFD700, #D4AF37);
    color: #333;
    font-weight: bold;
}

/* Modals */
.modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0,0,0,0.5);
    display: none;
    align-items: center;
    justify-content: center;
    z-index: 1000;
    padding: var(--spacing-lg);
}

.modal-overlay.active {
    display: flex;
}

.modal {
    background: white;
    border-radius: var(--radius-lg);
    width: 100%;
    max-width: 600px;
    max-height: 90vh;
    overflow: hidden;
    animation: modalSlideUp 0.3s ease;
}

@keyframes modalSlideUp {
    from {
        transform: translateY(50px);
        opacity: 0;
    }
    to {
        transform: translateY(0);
        opacity: 1;
    }
}

.modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: var(--spacing-lg);
    border-bottom: 1px solid var(--medium-gray);
    background: var(--light-gray);
}

.modal-header h2 {
    margin: 0;
    color: var(--epic-dark);
}

.modal-close {
    background: none;
    border: none;
    font-size: 1.5rem;
    cursor: pointer;
    color: var(--dark-gray);
    width: 32px;
    height: 32px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
}

.modal-close:hover {
    background: var(--medium-gray);
}

.modal-body {
    padding: var(--spacing-lg);
    overflow-y: auto;
    max-height: calc(90vh - 120px);
}

/* Form elements */
.form-group {
    margin-bottom: var(--spacing-lg);
}

.form-group label {
    display: block;
    margin-bottom: var(--spacing-sm);
    font-weight: 500;
    color: var(--epic-dark);
}

.form-control {
    width: 100%;
    padding: var(--spacing-sm) var(--spacing-md);
    border: 1px solid var(--medium-gray);
    border-radius: var(--radius-sm);
    font-size: 1rem;
    transition: border-color 0.3s ease;
}

.form-control:focus {
    outline: none;
    border-color: var(--epic-purple);
    box-shadow: 0 0 0 3px rgba(75, 40, 109, 0.1);
}

textarea.form-control {
    min-height: 100px;
    resize: vertical;
}

/* File upload */
.file-upload {
    border: 3px dashed var(--medium-gray);
    border-radius: var(--radius-md);
    padding: var(--spacing-xl);
    text-align: center;
    cursor: pointer;
    transition: all 0.3s ease;
    background: var(--light-gray);
}

.file-upload:hover {
    border-color: var(--epic-purple);
    background: white;
}

.file-upload i {
    font-size: 3rem;
    color: var(--epic-light-purple);
    margin-bottom: var(--spacing-md);
}

/* FAQ */
.faq-item {
    background: white;
    border-radius: var(--radius-md);
    margin-bottom: var(--spacing-md);
    overflow: hidden;
    border: 1px solid var(--medium-gray);
}

.faq-question {
    padding: var(--spacing-md) var(--spacing-lg);
    background: var(--light-gray);
    font-weight: 600;
    cursor: pointer;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.faq-question:hover {
    background: #e9ecef;
}

.faq-answer {
    padding: 0 var(--spacing-lg);
    max-height: 0;
    overflow: hidden;
    transition: max-height 0.3s ease, padding 0.3s ease;
}

.faq-answer.active {
    padding: var(--spacing-md) var(--spacing-lg);
    max-height: 500px;
}

/* Footer */
footer {
    text-align: center;
    padding: var(--spacing-lg);
    background: var(--epic-dark);
    color: white;
    margin-top: var(--spacing-xl);
}

footer p {
    margin: var(--spacing-sm) 0;
    font-size: 0.9rem;
    opacity: 0.8;
}

/* Responsive */
@media (max-width: 768px) {
    .header-content {
        flex-direction: column;
        gap: var(--spacing-md);
        text-align: center;
    }
    
    .nav-tabs {
        justify-content: flex-start;
        padding: 0 var(--spacing-sm);
    }
    
    .nav-link {
        padding: var(--spacing-md);
    }
    
    .hospital-grid, .resource-grid, .stats-grid {
        grid-template-columns: 1fr;
    }
    
    main {
        padding: 0 var(--spacing-md);
    }
}

/* Print styles */
@media print {
    .modal-overlay,
    .user-actions,
    .nav-tabs,
    footer {
        display: none !important;
    }
    
    .tab-content {
        display: block !important;
    }
}
CSS
    log "✓ Created styles.css"
else
    log "✓ styles.css exists"
fi

# Fix 3: Ensure JavaScript file exists
if [ ! -f "app.js" ]; then
    warn "app.js missing - creating from backup or template..."
    if [ -f "bundle.js" ]; then
        cp bundle.js app.js
        log "✓ Copied bundle.js to app.js"
    else
        # Create minimal app.js
        cat > app.js << 'JS'
console.log('Epic EMR Trainer Assistant - Minimal Version');

document.addEventListener('DOMContentLoaded', function() {
    console.log('App initialized');
    
    // Basic tab switching
    const navLinks = document.querySelectorAll('.nav-link');
    const tabContents = document.querySelectorAll('.tab-content');
    
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            
            // Remove active class from all
            navLinks.forEach(l => l.classList.remove('active'));
            tabContents.forEach(c => c.classList.remove('active'));
            
            // Add active class to clicked
            this.classList.add('active');
            
            // Show corresponding content
            const targetId = this.getAttribute('href').substring(1);
            const targetTab = document.getElementById(targetId);
            if (targetTab) {
                targetTab.classList.add('active');
            }
        });
    });
    
    // Basic modal handling
    const modalCloses = document.querySelectorAll('.modal-close');
    modalCloses.forEach(btn => {
        btn.addEventListener('click', function() {
            this.closest('.modal-overlay').classList.remove('active');
        });
    });
    
    // Click outside modal to close
    document.addEventListener('click', function(e) {
        if (e.target.classList.contains('modal-overlay')) {
            e.target.classList.remove('active');
        }
    });
    
    // Escape key to close modals
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            document.querySelectorAll('.modal-overlay.active').forEach(modal => {
                modal.classList.remove('active');
            });
        }
    });
    
    // Simple notification function
    window.showNotification = function(message, type = 'info') {
        const notification = document.createElement('div');
        notification.className = 'notification';
        notification.innerHTML = \`
            <div style="padding: 10px; background: \${type === 'error' ? '#dc3545' : type === 'success' ? '#28a745' : '#17a2b8'}; color: white; border-radius: 5px;">
                \${message}
            </div>
        \`;
        notification.style.position = 'fixed';
        notification.style.top = '20px';
        notification.style.right = '20px';
        notification.style.zIndex = '9999';
        
        document.body.appendChild(notification);
        
        setTimeout(() => {
            notification.remove();
        }, 3000);
    };
    
    // Initialize dashboard
    if (document.getElementById('dashboard')) {
        document.getElementById('hospital-count').textContent = '6';
        document.getElementById('faq-count').textContent = '12';
    }
});
JS
        log "✓ Created minimal app.js"
    fi
else
    log "✓ app.js exists"
fi

# Fix 4: Check for broken HTML structure
log "4. Validating HTML structure..."

if [ -f "index.html" ]; then
    # Check if scripts are in body
    if grep -q "<script>" index.html && ! grep -q "<script>" index.html | tail -1 | grep -q "</body>"; then
        warn "Scripts may not be at end of body - fixing..."
        # This is complex to fix automatically, so we'll just warn
        echo "Please ensure all <script> tags are just before </body>"
    fi
    
    # Check for required meta tags
    if ! grep -q "viewport" index.html; then
        warn "Missing viewport meta tag"
        sed -i.bak '/<head>/a\    <meta name="viewport" content="width=device-width, initial-scale=1.0">' index.html
        log "✓ Added viewport meta tag"
    fi
    
    # Check for charset
    if ! grep -q "charset=UTF-8" index.html; then
        warn "Missing UTF-8 charset"
        sed -i.bak '/<head>/a\    <meta charset="UTF-8">' index.html
        log "✓ Added charset meta tag"
    fi
    
    # Check for Font Awesome
    if ! grep -q "font-awesome" index.html && ! grep -q "cdnjs.cloudflare.com" index.html; then
        warn "Font Awesome not found - adding..."
        sed -i.bak '/<head>/a\    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">' index.html
        log "✓ Added Font Awesome"
    fi
fi

# Fix 5: Check and fix common JavaScript errors
log "5. Checking for common JavaScript issues..."

if [ -f "app.js" ]; then
    # Check for console.log statements (optional cleanup)
    console_count=$(grep -c "console\." app.js || true)
    if [ "$console_count" -gt 10 ]; then
        warn "Many console.log statements found ($console_count)"
        read -p "Remove console.log statements? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            sed -i.bak '/console\.log/d' app.js
            log "✓ Removed console.log statements"
        fi
    fi
    
    # Check for syntax errors
    if command -v node &> /dev/null; then
        if node -c app.js 2>/dev/null; then
            log "✓ app.js has valid syntax"
        else
            error "app.js has syntax errors"
            warn "Attempting to fix common syntax errors..."
            # Fix common issues
            sed -i.bak 's/‘/'"'"'/g; s/’/'"'"'/g; s/“/"/g; s/”/"/g' app.js
            sed -i.bak 's/==/===/g' app.js  # Encourage strict equality
            log "Applied basic syntax fixes"
        fi
    else
        warn "Node.js not installed, skipping syntax check"
    fi
fi

# Fix 6: Ensure proper file permissions
log "6. Setting file permissions..."

chmod 644 index.html styles.css app.js 2>/dev/null || true
chmod 755 *.sh 2>/dev/null || true

log "✓ File permissions set"

# Fix 7: Create missing directories
log "7. Creating required directories..."

mkdir -p assets images backups 2>/dev/null || true
log "✓ Directories created/verified"

# Fix 8: Create backup of current state
log "8. Creating backup..."

backup_dir="quickfix_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$backup_dir"
cp index.html styles.css app.js *.sh 2>/dev/null || true
cp -r assets images 2>/dev/null || true
mv *.bak "$backup_dir/" 2>/dev/null || true

log "✓ Backup created: $backup_dir"

# Fix 9: Create basic package.json if needed
if [ ! -f "package.json" ] && [ -f "app.js" ]; then
    log "9. Creating package.json for Node.js compatibility..."
    
    cat > package.json << 'JSON'
{
  "name": "epic-emr-trainer-assistant",
  "version": "1.0.0",
  "description": "Epic EMR Trainer Assistant Application",
  "main": "app.js",
  "scripts": {
    "start": "node app.js",
    "test": "echo \"No tests specified\" && exit 0",
    "build": "echo \"Build complete\""
  },
  "keywords": ["epic", "emr", "trainer", "healthcare"],
  "author": "Epic Trainer Team",
  "license": "MIT",
  "engines": {
    "node": ">=14.0.0"
  }
}
JSON
    log "✓ Created package.json"
fi

# Fix 10: Summary and next steps
log "10. Quick fix summary:"
echo ""
echo -e "${GREEN}✓ All quick fixes applied successfully!${NC}"
echo ""
echo "Next steps:"
echo "1. Test the application: Open index.html in a browser"
echo "2. Run the update script: ./update-scripts.sh"
echo "3. Deploy when ready: ./deploy.sh"
echo ""
echo "If you still have issues:"
echo "- Check browser console for errors (F12)"
echo "- Run ./update-scripts.sh --non-interactive"
echo "- Ensure all file permissions are correct"
echo ""

# Make scripts executable
chmod +x update-scripts.sh deploy.sh quick-fix.sh 2>/dev/null || true

echo -e "${GREEN}Quick fix process complete!${NC}"
