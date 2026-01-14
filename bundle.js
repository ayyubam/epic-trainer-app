// ===================================================================
// EPIC EMR TRAINER ASSISTANT - BUNDLED JAVASCRIPT
// Generated: Wed Jan 14 07:13:40 CST 2026
// ===================================================================

// === FILE: app.js ===

// ==================== EPIC EMR TRAINER ASSISTANT - MAIN APP ====================
// Version: 1.0.0
// Last Updated: 2024-01-14

console.log('Initializing Epic EMR Trainer Assistant...');

// ==================== APP STATE ====================
const appState = {
    // User state
    user: {
        isPremium: false,
        isLoggedIn: false,
        name: 'John Smith',
        email: 'john.smith@mercygeneral.org',
        hospital: 'Mercy General Hospital',
        role: 'Epic Certified Trainer'
    },
    
    // Data storage
    savedItems: [],
    uploads: [],
    
    // Current state
    currentTab: 'dashboard',
    mediaCache: new Map()
};

// ==================== UTILITY FUNCTIONS ====================
function formatFileSize(bytes) {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB', 'GB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
}

function showNotification(message, type = 'info') {
    // Remove existing notifications
    document.querySelectorAll('.notification').forEach(n => n.remove());
    
    const notification = document.createElement('div');
    notification.className = 'notification';
    notification.innerHTML = `
        <div class="notification-content">
            <i class="fas fa-${type === 'success' ? 'check-circle' : type === 'error' ? 'exclamation-circle' : type === 'warning' ? 'exclamation-triangle' : 'info-circle'}"></i>
            <span>${message}</span>
        </div>
        <button class="notification-close">&times;</button>
    `;
    
    // Add styles if not present
    if (!document.querySelector('#notification-styles')) {
        const style = document.createElement('style');
        style.id = 'notification-styles';
        style.textContent = `
            .notification {
                position: fixed;
                top: 20px;
                right: 20px;
                background: ${type === 'success' ? '#28a745' : type === 'error' ? '#dc3545' : type === 'warning' ? '#ffc107' : '#17a2b8'};
                color: white;
                padding: 15px 20px;
                border-radius: 8px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.2);
                z-index: 10000;
                display: flex;
                align-items: center;
                justify-content: space-between;
                gap: 15px;
                min-width: 300px;
                max-width: 400px;
                animation: slideInRight 0.3s ease;
            }
            
            .notification-content {
                display: flex;
                align-items: center;
                gap: 10px;
                flex: 1;
            }
            
            .notification-close {
                background: none;
                border: none;
                color: white;
                font-size: 20px;
                cursor: pointer;
                padding: 0;
                width: 24px;
                height: 24px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 50%;
            }
            
            .notification-close:hover {
                background: rgba(255,255,255,0.2);
            }
            
            @keyframes slideInRight {
                from { transform: translateX(100%); opacity: 0; }
                to { transform: translateX(0); opacity: 1; }
            }
        `;
        document.head.appendChild(style);
    }
    
    document.body.appendChild(notification);
    
    // Auto-remove after 3 seconds
    setTimeout(() => {
        if (notification.parentNode) {
            notification.parentNode.removeChild(notification);
        }
    }, 3000);
    
    // Close button
    notification.querySelector('.notification-close').addEventListener('click', () => {
        notification.remove();
    });
}

function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

function getFileIcon(fileType) {
    if (fileType.startsWith('video/')) return 'fa-file-video';
    if (fileType.startsWith('audio/')) return 'fa-file-audio';
    if (fileType.startsWith('image/')) return 'fa-file-image';
    if (fileType.includes('pdf')) return 'fa-file-pdf';
    if (fileType.includes('word')) return 'fa-file-word';
    if (fileType.includes('excel')) return 'fa-file-excel';
    if (fileType.includes('powerpoint')) return 'fa-file-powerpoint';
    if (fileType.includes('zip') || fileType.includes('compressed')) return 'fa-file-archive';
    return 'fa-file';
}

// ==================== STORAGE MANAGEMENT ====================
function initializeStorage() {
    try {
        const saved = localStorage.getItem('epic_trainer_saved');
        const uploads = localStorage.getItem('epic_trainer_uploads');
        const user = localStorage.getItem('epic_trainer_user');
        
        if (saved) appState.savedItems = JSON.parse(saved);
        if (uploads) appState.uploads = JSON.parse(uploads);
        if (user) appState.user = JSON.parse(user);
        
        console.log('Storage initialized successfully');
    } catch (error) {
        console.error('Error loading storage:', error);
        // Initialize with defaults
        appState.savedItems = [];
        appState.uploads = [];
    }
}

function saveStorage() {
    try {
        localStorage.setItem('epic_trainer_saved', JSON.stringify(appState.savedItems));
        localStorage.setItem('epic_trainer_uploads', JSON.stringify(appState.uploads));
        localStorage.setItem('epic_trainer_user', JSON.stringify(appState.user));
    } catch (error) {
        console.error('Error saving to storage:', error);
    }
}

// ==================== TAB NAVIGATION ====================
function setupTabNavigation() {
    const navLinks = document.querySelectorAll('.nav-link');
    const tabContents = document.querySelectorAll('.tab-content');
    
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            
            const targetId = this.getAttribute('href').substring(1);
            
            // Update active nav link
            navLinks.forEach(l => l.classList.remove('active'));
            this.classList.add('active');
            
            // Hide all tabs
            tabContents.forEach(content => {
                content.classList.remove('active');
            });
            
            // Show target tab
            const targetTab = document.getElementById(targetId);
            if (targetTab) {
                targetTab.classList.add('active');
                appState.currentTab = targetId;
                
                // Load tab-specific content
                loadTabContent(targetId);
            }
        });
    });
}

function loadTabContent(tabId) {
    switch(tabId) {
        case 'dashboard':
            updateDashboardStats();
            break;
        case 'hospitals':
            loadHospitals();
            break;
        case 'faq':
            loadFAQs();
            break;
        case 'resources':
            loadResources();
            break;
        case 'go-live':
            updateGoLiveStats();
            break;
        case 'profile':
            updateProfile();
            break;
    }
}

// ==================== MODAL MANAGEMENT ====================
function setupModals() {
    // Modal close buttons
    document.querySelectorAll('.modal-close').forEach(btn => {
        btn.addEventListener('click', function() {
            this.closest('.modal-overlay').classList.remove('active');
        });
    });
    
    // Click outside to close
    document.addEventListener('click', function(e) {
        if (e.target.classList.contains('modal-overlay')) {
            e.target.classList.remove('active');
        }
    });
    
    // Escape key to close
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            document.querySelectorAll('.modal-overlay.active').forEach(modal => {
                modal.classList.remove('active');
            });
        }
    });
    
    // Upload modal
    const uploadBtn = document.getElementById('upload-resource-btn');
    const uploadModal = document.getElementById('upload-modal');
    
    if (uploadBtn && uploadModal) {
        uploadBtn.addEventListener('click', () => {
            uploadModal.classList.add('active');
        });
    }
    
    // File upload handling
    const fileUploadArea = document.getElementById('file-upload-area');
    const fileInput = document.getElementById('file-input');
    
    if (fileUploadArea && fileInput) {
        fileUploadArea.addEventListener('click', () => fileInput.click());
        
        fileInput.addEventListener('change', function(e) {
            if (e.target.files.length > 0) {
                const file = e.target.files[0];
                const fileName = document.getElementById('file-name');
                const fileSize = document.getElementById('file-size');
                const fileInfo = document.getElementById('file-info');
                
                if (fileName) fileName.textContent = file.name;
                if (fileSize) fileSize.textContent = formatFileSize(file.size);
                if (fileInfo) fileInfo.style.display = 'block';
            }
        });
    }
    
    // Start upload button
    const startUploadBtn = document.getElementById('start-upload-btn');
    if (startUploadBtn) {
        startUploadBtn.addEventListener('click', handleFileUpload);
    }
}

function handleFileUpload() {
    const fileInput = document.getElementById('file-input');
    const titleInput = document.getElementById('doc-title');
    const startBtn = document.getElementById('start-upload-btn');
    
    if (!fileInput.files.length) {
        showNotification('Please select a file to upload', 'warning');
        return;
    }
    
    if (!titleInput.value.trim()) {
        showNotification('Please enter a document title', 'warning');
        return;
    }
    
    const file = fileInput.files[0];
    const originalBtnHTML = startBtn.innerHTML;
    
    // Show loading state
    startBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Uploading...';
    startBtn.disabled = true;
    
    // Simulate upload
    setTimeout(() => {
        const newUpload = {
            id: 'upload-' + Date.now(),
            title: titleInput.value,
            filename: file.name,
            size: file.size,
            type: file.type,
            uploadedAt: new Date().toISOString(),
            description: document.getElementById('doc-description').value || '',
            category: document.getElementById('doc-category').value || 'other'
        };
        
        appState.uploads.push(newUpload);
        saveStorage();
        
        // Close modal
        document.getElementById('upload-modal').classList.remove('active');
        
        // Reset form
        document.getElementById('doc-title').value = '';
        document.getElementById('doc-description').value = '';
        document.getElementById('doc-category').value = '';
        document.getElementById('file-input').value = '';
        document.getElementById('file-info').style.display = 'none';
        
        // Reset button
        startBtn.innerHTML = originalBtnHTML;
        startBtn.disabled = false;
        
        showNotification(`"${newUpload.title}" uploaded successfully!`, 'success');
        
        // Update uploads display if on profile tab
        if (appState.currentTab === 'profile') {
            updateProfileUploads();
        }
    }, 1500);
}

// ==================== CONTENT LOADING ====================
function updateDashboardStats() {
    // Update hospital count
    const hospitalCount = document.getElementById('hospital-count');
    if (hospitalCount) hospitalCount.textContent = '6';
    
    // Update FAQ count
    const faqCount = document.getElementById('faq-count');
    if (faqCount) faqCount.textContent = '12';
}

function loadHospitals() {
    const hospitalList = document.getElementById('hospital-list');
    if (!hospitalList) return;
    
    // Sample hospital data
    const hospitals = [
        {
            id: 1,
            name: 'Mayo Clinic',
            version: 'Epic 2023',
            modules: ['Radiant', 'Beaker', 'OpTime'],
            contact: 'Dr. Sarah Johnson',
            goLiveDate: '2022-06-15',
            successRate: '98%'
        },
        {
            id: 2,
            name: 'Johns Hopkins Hospital',
            version: 'Epic 2023',
            modules: ['Care Everywhere', 'MyChart', 'Healthy Planet'],
            contact: 'Michael Chen',
            goLiveDate: '2023-03-22',
            successRate: '96%'
        },
        {
            id: 3,
            name: 'Massachusetts General Hospital',
            version: 'Epic 2022',
            modules: ['Cadence', 'Prelude', 'Grand Central'],
            contact: 'Emily Rodriguez',
            goLiveDate: '2021-11-30',
            successRate: '99%'
        }
    ];
    
    hospitalList.innerHTML = '';
    hospitals.forEach(hospital => {
        const card = document.createElement('div');
        card.className = 'hospital-card';
        card.innerHTML = `
            <h3><i class="fas fa-hospital"></i> ${hospital.name}</h3>
            <div class="hospital-meta">
                <span><i class="fas fa-code-branch"></i> ${hospital.version}</span>
                <span><i class="fas fa-calendar-alt"></i> ${hospital.goLiveDate}</span>
            </div>
            <p><strong>Contact:</strong> ${hospital.contact}</p>
            <div class="module-list">
                ${hospital.modules.map(m => `<span class="module-tag">${m}</span>`).join('')}
            </div>
            <div class="hospital-actions">
                <button class="btn btn-primary" onclick="viewHospitalDetails(${hospital.id})">
                    View Details
                </button>
                <button class="btn btn-outline save-btn" data-id="hosp-${hospital.id}">
                    <i class="fas fa-bookmark"></i> Save
                </button>
            </div>
        `;
        hospitalList.appendChild(card);
    });
}

function loadFAQs() {
    const faqContainer = document.querySelector('.faq-container');
    if (!faqContainer) return;
    
    const faqs = [
        {
            id: 1,
            question: 'How do I access the Epic Playground?',
            answer: 'Access to the Epic Playground varies by organization. Typically, you need to connect through your organization\'s VPN and use a specific URL provided by your Epic team.',
            category: 'Access'
        },
        {
            id: 2,
            question: 'What\'s the difference between Hyperspace and Hyperdrive?',
            answer: 'Hyperspace is the traditional Epic interface, while Hyperdrive is the newer, web-based version that offers improved performance and customization options.',
            category: 'Navigation'
        }
    ];
    
    faqContainer.innerHTML = '';
    faqs.forEach(faq => {
        const item = document.createElement('div');
        item.className = 'faq-item';
        item.innerHTML = `
            <div class="faq-question">
                ${faq.question} <span>+</span>
            </div>
            <div class="faq-answer">
                <p>${faq.answer}</p>
                <div class="faq-meta">
                    <span class="faq-category">${faq.category}</span>
                    <button class="btn btn-outline save-btn" data-id="faq-${faq.id}">
                        <i class="fas fa-bookmark"></i> Save Answer
                    </button>
                </div>
            </div>
        `;
        faqContainer.appendChild(item);
    });
    
    // FAQ toggle functionality
    document.querySelectorAll('.faq-question').forEach(question => {
        question.addEventListener('click', function() {
            const answer = this.nextElementSibling;
            const icon = this.querySelector('span');
            
            answer.classList.toggle('active');
            icon.textContent = answer.classList.contains('active') ? '−' : '+';
        });
    });
}

function loadResources() {
    // Resource loading logic
    console.log('Loading resources...');
}

function updateGoLiveStats() {
    const statsContainer = document.querySelector('#go-live .stats-grid');
    if (!statsContainer) return;
    
    statsContainer.innerHTML = `
        <div class="stat-card">
            <i class="fas fa-hospital"></i>
            <h3>6</h3>
            <p>Hospital Systems</p>
        </div>
        <div class="stat-card">
            <i class="fas fa-users"></i>
            <h3>58</h3>
            <p>Total Epic Team</p>
        </div>
        <div class="stat-card">
            <i class="fas fa-chart-line"></i>
            <h3>97.5%</h3>
            <p>Average Success</p>
        </div>
        <div class="stat-card">
            <i class="fas fa-graduation-cap"></i>
            <h3>8,650</h3>
            <p>Users Trained</p>
        </div>
    `;
}

function updateProfile() {
    // Update user info
    const userAvatar = document.querySelector('.profile-avatar i');
    const userName = document.querySelector('.profile-header h2');
    const userEmail = document.querySelector('.profile-header p:nth-child(3)');
    
    if (userAvatar) userAvatar.className = 'fas fa-user';
    if (userName) userName.textContent = appState.user.name;
    if (userEmail) userEmail.textContent = appState.user.email;
    
    // Update saved items
    updateProfileSaved();
    
    // Update uploads
    updateProfileUploads();
}

function updateProfileSaved() {
    const savedTab = document.getElementById('saved-tab');
    if (!savedTab) return;
    
    if (appState.savedItems.length === 0) {
        savedTab.innerHTML = `
            <div class="empty-state">
                <i class="fas fa-bookmark"></i>
                <h3>No Saved Content</h3>
                <p>Save hospitals, resources, or FAQs to see them here.</p>
            </div>
        `;
        return;
    }
    
    savedTab.innerHTML = `
        <h3>Saved Items (${appState.savedItems.length})</h3>
        <div class="saved-items-grid">
            ${appState.savedItems.map(item => `
                <div class="saved-item">
                    <i class="fas fa-${item.type === 'hospital' ? 'hospital' : item.type === 'resource' ? 'file' : 'question-circle'}"></i>
                    <h4>${item.title}</h4>
                    <p>Saved on ${new Date(item.savedAt).toLocaleDateString()}</p>
                </div>
            `).join('')}
        </div>
    `;
}

function updateProfileUploads() {
    const uploadsTab = document.getElementById('uploads-tab');
    if (!uploadsTab) return;
    
    if (appState.uploads.length === 0) {
        uploadsTab.innerHTML = `
            <h3>My Uploads</h3>
            <div class="empty-state">
                <i class="fas fa-cloud-upload-alt"></i>
                <p>You haven't uploaded any resources yet.</p>
                <button class="btn btn-primary" onclick="document.getElementById('upload-modal').classList.add('active')">
                    <i class="fas fa-upload"></i> Upload Resource
                </button>
            </div>
        `;
        return;
    }
    
    uploadsTab.innerHTML = `
        <h3>My Uploads (${appState.uploads.length})</h3>
        <div class="uploads-grid">
            ${appState.uploads.map(upload => `
                <div class="upload-card">
                    <div class="upload-header">
                        <i class="fas ${getFileIcon(upload.type)}"></i>
                        <h4>${upload.title}</h4>
                    </div>
                    <div class="upload-meta">
                        <span>${upload.category}</span>
                        <span>${formatFileSize(upload.size)}</span>
                        <span>${new Date(upload.uploadedAt).toLocaleDateString()}</span>
                    </div>
                    <p>${upload.description || 'No description'}</p>
                    <div class="upload-actions">
                        <button class="btn btn-outline" onclick="downloadUpload('${upload.id}')">
                            <i class="fas fa-download"></i> Download
                        </button>
                    </div>
                </div>
            `).join('')}
        </div>
    `;
}

// ==================== HELPER FUNCTIONS ====================
function viewHospitalDetails(hospitalId) {
    showNotification('Hospital details would open here', 'info');
}

function downloadUpload(uploadId) {
    showNotification('Download started', 'success');
}

function openSimulator() {
    showNotification('Training Simulator opening...', 'info');
}

function openStaffingCalculator() {
    showNotification('Staffing Calculator opening...', 'info');
}

// ==================== SAVE FUNCTIONALITY ====================
function setupSaveButtons() {
    document.addEventListener('click', function(e) {
        if (e.target.closest('.save-btn')) {
            const button = e.target.closest('.save-btn');
            const itemId = button.getAttribute('data-id');
            const itemType = itemId.startsWith('hosp-') ? 'hospital' : 
                            itemId.startsWith('faq-') ? 'faq' : 'resource';
            
            // Check if already saved
            const existingIndex = appState.savedItems.findIndex(item => item.id === itemId);
            
            if (existingIndex >= 0) {
                // Remove from saved
                appState.savedItems.splice(existingIndex, 1);
                button.innerHTML = '<i class="fas fa-bookmark"></i> Save';
                button.classList.remove('saved');
                showNotification('Item removed from saved', 'info');
            } else {
                // Add to saved
                const item = {
                    id: itemId,
                    type: itemType,
                    title: button.closest('.hospital-card, .resource-card, .faq-item')?.querySelector('h3')?.textContent || 'Untitled Item',
                    savedAt: new Date().toISOString()
                };
                
                appState.savedItems.push(item);
                button.innerHTML = '<i class="fas fa-check"></i> Saved';
                button.classList.add('saved');
                showNotification('Item saved to profile!', 'success');
            }
            
            saveStorage();
            
            // Update profile if open
            if (appState.currentTab === 'profile') {
                updateProfileSaved();
            }
        }
    });
}

// ==================== SEARCH FUNCTIONALITY ====================
function setupSearch() {
    const searchBoxes = document.querySelectorAll('.search-box');
    
    searchBoxes.forEach(box => {
        box.addEventListener('input', debounce(function(e) {
            const searchTerm = e.target.value.toLowerCase();
            const tabId = e.target.closest('.tab-content')?.id;
            
            if (tabId === 'hospitals') {
                searchHospitals(searchTerm);
            } else if (tabId === 'faq') {
                searchFAQs(searchTerm);
            }
        }, 300));
    });
}

function searchHospitals(term) {
    const cards = document.querySelectorAll('#hospital-list .hospital-card');
    cards.forEach(card => {
        const text = card.textContent.toLowerCase();
        card.style.display = text.includes(term) ? 'block' : 'none';
    });
}

function searchFAQs(term) {
    const items = document.querySelectorAll('.faq-item');
    items.forEach(item => {
        const text = item.textContent.toLowerCase();
        item.style.display = text.includes(term) ? 'block' : 'none';
    });
}

// ==================== UPGRADE FUNCTIONALITY ====================
function setupUpgradeButtons() {
    const upgradeBtns = document.querySelectorAll('#upgrade-btn, #upgrade-btn-2');
    
    upgradeBtns.forEach(btn => {
        btn.addEventListener('click', function() {
            const modal = document.getElementById('upgrade-modal');
            if (modal) modal.classList.add('active');
        });
    });
    
    const startTrialBtn = document.getElementById('start-trial-btn');
    if (startTrialBtn) {
        startTrialBtn.addEventListener('click', function() {
            appState.user.isPremium = true;
            appState.user.isLoggedIn = true;
            saveStorage();
            
            // Update UI
            const premiumBadge = document.getElementById('premium-status');
            if (premiumBadge) {
                premiumBadge.innerHTML = '<i class="fas fa-crown"></i> Premium Member';
            }
            
            // Close modal
            document.getElementById('upgrade-modal').classList.remove('active');
            
            showNotification('Welcome to Premium! All features unlocked.', 'success');
            
            // Update profile
            updateProfile();
        });
    }
}

// ==================== PROFILE TABS ====================
function setupProfileTabs() {
    const profileTabs = document.querySelectorAll('.profile-tab');
    const profileContents = document.querySelectorAll('.profile-tab-content');
    
    profileTabs.forEach(tab => {
        tab.addEventListener('click', function() {
            const tabId = this.getAttribute('data-tab');
            
            // Update active tab
            profileTabs.forEach(t => t.classList.remove('active'));
            this.classList.add('active');
            
            // Show content
            profileContents.forEach(content => content.classList.remove('active'));
            const targetContent = document.getElementById(`${tabId}-tab`);
            if (targetContent) targetContent.classList.add('active');
        });
    });
}

// ==================== INITIALIZATION ====================
function initializeApp() {
    console.log('Starting app initialization...');
    
    // Load storage
    initializeStorage();
    
    // Setup navigation
    setupTabNavigation();
    
    // Setup modals
    setupModals();
    
    // Setup save functionality
    setupSaveButtons();
    
    // Setup search
    setupSearch();
    
    // Setup upgrade
    setupUpgradeButtons();
    
    // Setup profile tabs
    setupProfileTabs();
    
    // Load initial tab
    loadTabContent('dashboard');
    
    console.log('App initialization complete!');
}

// ==================== START APP ====================
document.addEventListener('DOMContentLoaded', initializeApp);

// ==================== GLOBAL FUNCTIONS ====================
// Make essential functions globally available
window.showNotification = showNotification;
window.openSimulator = openSimulator;
window.openStaffingCalculator = openStaffingCalculator;
window.viewHospitalDetails = viewHospitalDetails;
window.downloadUpload = downloadUpload;

// === END OF app.js ===

