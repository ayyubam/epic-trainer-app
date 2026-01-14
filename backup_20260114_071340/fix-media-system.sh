#!/bin/bash

# Backup current file
cp index.html index.html.backup.media

# Find and replace the problematic viewUploadedMedia function
# Create new complete media system
cat > media-system.html << 'MEDIAEOF'

<!-- COMPLETE MEDIA MANAGEMENT SYSTEM -->
<script>
// ==================== ENHANCED MEDIA UPLOAD SYSTEM ====================

// Global media player state
const mediaPlayer = {
    currentMedia: null,
    player: null
};

// Convert file to Base64
function fileToBase64(file) {
    return new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.readAsDataURL(file);
        reader.onload = () => resolve(reader.result);
        reader.onerror = error => reject(error);
    });
}

// Enhanced upload handler
async function handleRealFileUpload() {
    const fileInput = document.getElementById('file-input');
    const title = document.getElementById('doc-title').value;
    const description = document.getElementById('doc-description').value;
    const category = document.getElementById('doc-category').value;
    
    if (!title.trim()) {
        showNotification('Please enter a document title', 'warning');
        return;
    }
    
    if (fileInput.files.length === 0) {
        showNotification('Please select a file to upload', 'warning');
        return;
    }
    
    const file = fileInput.files[0];
    const maxSize = 5 * 1024 * 1024; // 5MB limit for localStorage demo
    
    if (file.size > maxSize) {
        showNotification('File size exceeds 5MB limit for demo version. Please use smaller files.', 'error');
        return;
    }
    
    // Check file type
    const allowedTypes = [
        'video/mp4', 'video/webm', 'video/ogg',
        'image/jpeg', 'image/png', 'image/gif', 'image/webp',
        'application/pdf',
        'application/msword',
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        'text/plain'
    ];
    
    if (!allowedTypes.includes(file.type)) {
        showNotification('File type not supported. Please upload videos (MP4, WebM, OGG), images (JPG, PNG, GIF), PDFs, or documents.', 'error');
        return;
    }
    
    const uploadBtn = document.getElementById('start-upload-btn');
    uploadBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
    uploadBtn.disabled = true;
    
    try {
        // Show upload progress
        showNotification('Converting file for storage...', 'info');
        
        // Convert file to Base64
        const base64Data = await fileToBase64(file);
        
        // Create upload object
        const newUpload = {
            id: 'upload-' + Date.now() + '-' + Math.random().toString(36).substr(2, 9),
            title: title,
            description: description,
            category: category,
            filename: file.name,
            size: file.size,
            type: file.type,
            base64Data: base64Data,
            uploadedAt: new Date().toISOString(),
            public: document.getElementById('doc-public').checked,
            tags: document.getElementById('doc-tags').value.split(',').map(tag => tag.trim()).filter(tag => tag),
            hospital: document.getElementById('doc-hospital').value,
            viewCount: 0,
            lastViewed: null
        };
        
        // Store in localStorage
        userState.uploads.push(newUpload);
        saveToStorage();
        
        showNotification('"' + title + '" uploaded successfully! You can now play/view it.', 'success');
        
        // Close modal and reset
        document.getElementById('upload-modal').classList.remove('active');
        resetUploadForm();
        
        // Update display
        updateUploadsDisplay();
        
    } catch (error) {
        console.error('Upload error:', error);
        showNotification('Upload failed: ' + error.message, 'error');
    } finally {
        uploadBtn.innerHTML = '<i class="fas fa-upload"></i> Upload Document';
        uploadBtn.disabled = false;
    }
}

// View/Play uploaded media
function openMediaPlayer(uploadId) {
    const upload = userState.uploads.find(u => u.id === uploadId);
    if (!upload) {
        showNotification('File not found', 'error');
        return;
    }
    
    // Update view count
    upload.viewCount = (upload.viewCount || 0) + 1;
    upload.lastViewed = new Date().toISOString();
    saveToStorage();
    
    // Create media player modal
    const mediaType = upload.type.split('/')[0];
    
    let playerHTML = '';
    
    if (mediaType === 'video') {
        playerHTML = `
            <div class="video-player-container">
                <video id="media-player" controls autoplay style="width: 100%; max-height: 60vh; border-radius: 8px;">
                    <source src="${upload.base64Data}" type="${upload.type}">
                    Your browser does not support HTML5 video.
                </video>
                <div class="video-controls">
                    <button onclick="toggleFullscreen()" class="btn btn-sm btn-outline">
                        <i class="fas fa-expand"></i> Fullscreen
                    </button>
                    <button onclick="downloadMedia('${upload.id}')" class="btn btn-sm btn-outline">
                        <i class="fas fa-download"></i> Download
                    </button>
                    <button onclick="shareMedia('${upload.id}')" class="btn btn-sm btn-outline">
                        <i class="fas fa-share"></i> Share
                    </button>
                </div>
            </div>
        `;
    } else if (mediaType === 'image') {
        playerHTML = `
            <div class="image-viewer-container">
                <img src="${upload.base64Data}" id="media-image" 
                     style="width: 100%; max-height: 60vh; object-fit: contain; border-radius: 8px;">
                <div class="image-controls">
                    <button onclick="zoomImage(1.2)" class="btn btn-sm btn-outline">
                        <i class="fas fa-search-plus"></i> Zoom In
                    </button>
                    <button onclick="zoomImage(0.8)" class="btn btn-sm btn-outline">
                        <i class="fas fa-search-minus"></i> Zoom Out
                    </button>
                    <button onclick="downloadMedia('${upload.id}')" class="btn btn-sm btn-outline">
                        <i class="fas fa-download"></i> Download
                    </button>
                </div>
            </div>
        `;
    } else {
        // For documents
        playerHTML = `
            <div class="document-viewer">
                <div class="document-preview">
                    <i class="fas fa-file-${upload.type.includes('pdf') ? 'pdf' : 'word'}" 
                       style="font-size: 100px; color: var(--epic-purple); margin-bottom: 20px;"></i>
                    <h3>${upload.title}</h3>
                    <p>This is a ${upload.type} document. Click Download to save it to your device.</p>
                </div>
                <div class="document-info">
                    <p><strong>File Type:</strong> ${upload.type}</p>
                    <p><strong>File Size:</strong> ${formatFileSize(upload.size)}</p>
                    <p><strong>Uploaded:</strong> ${new Date(upload.uploadedAt).toLocaleDateString()}</p>
                </div>
            </div>
        `;
    }
    
    const modalHTML = `
        <div class="modal-overlay active" id="media-player-modal">
            <div class="modal" style="max-width: 90%; max-height: 90vh; width: 800px;">
                <div class="modal-header">
                    <h2><i class="fas fa-${mediaType === 'video' ? 'play-circle' : mediaType === 'image' ? 'image' : 'file'}"></i> 
                        ${upload.title}
                    </h2>
                    <div class="media-stats">
                        <span class="stat"><i class="fas fa-eye"></i> ${upload.viewCount || 0} views</span>
                        <span class="stat"><i class="fas fa-download"></i> ${upload.downloadCount || 0} downloads</span>
                    </div>
                    <button class="modal-close" onclick="closeMediaPlayer()">&times;</button>
                </div>
                
                <div class="modal-body" style="padding: 20px; overflow-y: auto;">
                    ${playerHTML}
                    
                    <div class="media-details" style="margin-top: 20px; padding-top: 20px; border-top: 1px solid #dee2e6;">
                        <h4><i class="fas fa-info-circle"></i> File Details</h4>
                        <div class="details-grid">
                            <div class="detail">
                                <strong>Description:</strong>
                                <p>${upload.description || 'No description provided.'}</p>
                            </div>
                            <div class="detail">
                                <strong>Category:</strong>
                                <span>${upload.category || 'Uncategorized'}</span>
                            </div>
                            <div class="detail">
                                <strong>Tags:</strong>
                                <div class="tags">
                                    ${upload.tags && upload.tags.length > 0 ? 
                                        upload.tags.map(tag => `<span class="tag">${tag}</span>`).join('') : 
                                        '<span class="text-muted">No tags</span>'}
                                </div>
                            </div>
                            <div class="detail">
                                <strong>Visibility:</strong>
                                <span class="badge ${upload.public ? 'public' : 'private'}">
                                    <i class="fas fa-${upload.public ? 'globe' : 'lock'}"></i>
                                    ${upload.public ? 'Public' : 'Private'}
                                </span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="media-actions" style="margin-top: 20px; display: flex; gap: 10px; flex-wrap: wrap;">
                        <button onclick="downloadMedia('${upload.id}')" class="btn btn-primary">
                            <i class="fas fa-download"></i> Download File
                        </button>
                        <button onclick="shareMedia('${upload.id}')" class="btn btn-outline">
                            <i class="fas fa-share"></i> Share
                        </button>
                        <button onclick="editMedia('${upload.id}')" class="btn btn-outline">
                            <i class="fas fa-edit"></i> Edit Details
                        </button>
                        <button onclick="deleteMedia('${upload.id}')" class="btn btn-outline" style="color: var(--danger);">
                            <i class="fas fa-trash"></i> Delete
                        </button>
                    </div>
                </div>
            </div>
        </div>
    `;
    
    // Remove existing modal if any
    const existingModal = document.getElementById('media-player-modal');
    if (existingModal) existingModal.remove();
    
    // Add new modal
    document.body.insertAdjacentHTML('beforeend', modalHTML);
    
    // Initialize video player if video
    if (mediaType === 'video') {
        const video = document.getElementById('media-player');
        if (video) {
            mediaPlayer.player = video;
            video.play().catch(e => console.log('Auto-play prevented:', e));
        }
    }
    
    // Initialize image zoom if image
    if (mediaType === 'image') {
        const img = document.getElementById('media-image');
        if (img) {
            img.style.transform = 'scale(1)';
            img.style.transition = 'transform 0.3s ease';
        }
    }
}

// Close media player
function closeMediaPlayer() {
    if (mediaPlayer.player) {
        mediaPlayer.player.pause();
        mediaPlayer.player = null;
    }
    
    const modal = document.getElementById('media-player-modal');
    if (modal) modal.remove();
}

// Download media
function downloadMedia(uploadId) {
    const upload = userState.uploads.find(u => u.id === uploadId);
    if (!upload) {
        showNotification('File not found', 'error');
        return;
    }
    
    // Update download count
    upload.downloadCount = (upload.downloadCount || 0) + 1;
    saveToStorage();
    
    // Create download link
    const link = document.createElement('a');
    link.href = upload.base64Data;
    link.download = upload.filename;
    link.style.display = 'none';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    
    showNotification('Download started: ' + upload.filename, 'success');
}

// Share media
function shareMedia(uploadId) {
    const upload = userState.uploads.find(u => u.id === uploadId);
    if (!upload) return;
    
    const shareUrl = window.location.origin + window.location.pathname + '#media=' + uploadId;
    
    if (navigator.share) {
        navigator.share({
            title: upload.title,
            text: upload.description || 'Check out this Epic resource',
            url: shareUrl
        }).catch(err => {
            console.log('Share cancelled:', err);
        });
    } else {
        // Copy to clipboard
        const textArea = document.createElement('textarea');
        textArea.value = `${upload.title}\n\n${upload.description || ''}\n\nView online: ${shareUrl}`;
        document.body.appendChild(textArea);
        textArea.select();
        document.execCommand('copy');
        document.body.removeChild(textArea);
        showNotification('Link copied to clipboard!', 'success');
    }
}

// Edit media details
function editMedia(uploadId) {
    const upload = userState.uploads.find(u => u.id === uploadId);
    if (!upload) return;
    
    const editHTML = `
        <div class="modal-overlay active" id="edit-media-modal">
            <div class="modal" style="max-width: 500px;">
                <div class="modal-header">
                    <h2><i class="fas fa-edit"></i> Edit Media Details</h2>
                    <button class="modal-close" onclick="closeModal('edit-media-modal')">&times;</button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="edit-title">Title</label>
                        <input type="text" id="edit-title" class="form-control" value="${upload.title}">
                    </div>
                    <div class="form-group">
                        <label for="edit-description">Description</label>
                        <textarea id="edit-description" class="form-control" rows="3">${upload.description || ''}</textarea>
                    </div>
                    <div class="form-group">
                        <label for="edit-category">Category</label>
                        <select id="edit-category" class="form-control">
                            <option value="">Select category</option>
                            <option value="training" ${upload.category === 'training' ? 'selected' : ''}>Training Video</option>
                            <option value="documentation" ${upload.category === 'documentation' ? 'selected' : ''}>Documentation</option>
                            <option value="presentation" ${upload.category === 'presentation' ? 'selected' : ''}>Presentation</option>
                            <option value="reference" ${upload.category === 'reference' ? 'selected' : ''}>Reference Material</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="checkbox">
                            <input type="checkbox" id="edit-public" ${upload.public ? 'checked' : ''}>
                            Make this file public
                        </label>
                    </div>
                    <div class="modal-actions">
                        <button onclick="saveMediaEdit('${uploadId}')" class="btn btn-primary">
                            <i class="fas fa-save"></i> Save Changes
                        </button>
                        <button onclick="closeModal('edit-media-modal')" class="btn btn-outline">
                            Cancel
                        </button>
                    </div>
                </div>
            </div>
        </div>
    `;
    
    closeMediaPlayer();
    document.body.insertAdjacentHTML('beforeend', editHTML);
}

// Save media edits
function saveMediaEdit(uploadId) {
    const upload = userState.uploads.find(u => u.id === uploadId);
    if (!upload) return;
    
    upload.title = document.getElementById('edit-title').value;
    upload.description = document.getElementById('edit-description').value;
    upload.category = document.getElementById('edit-category').value;
    upload.public = document.getElementById('edit-public').checked;
    
    saveToStorage();
    updateUploadsDisplay();
    closeModal('edit-media-modal');
    showNotification('Media details updated', 'success');
}

// Delete media
function deleteMedia(uploadId) {
    if (!confirm('Are you sure you want to delete this file? This action cannot be undone.')) {
        return;
    }
    
    const index = userState.uploads.findIndex(u => u.id === uploadId);
    if (index !== -1) {
        userState.uploads.splice(index, 1);
        saveToStorage();
        updateUploadsDisplay();
        closeMediaPlayer();
        showNotification('File deleted', 'info');
    }
}

// Toggle fullscreen
function toggleFullscreen() {
    const video = mediaPlayer.player;
    if (!video) return;
    
    if (!document.fullscreenElement) {
        if (video.requestFullscreen) {
            video.requestFullscreen();
        } else if (video.webkitRequestFullscreen) {
            video.webkitRequestFullscreen();
        }
    } else {
        if (document.exitFullscreen) {
            document.exitFullscreen();
        } else if (document.webkitExitFullscreen) {
            document.webkitExitFullscreen();
        }
    }
}

// Zoom image
function zoomImage(factor) {
    const img = document.getElementById('media-image');
    if (!img) return;
    
    const currentScale = parseFloat(img.style.transform.replace('scale(', '').replace(')', '')) || 1;
    const newScale = currentScale * factor;
    
    // Limit zoom
    if (newScale < 0.1) return;
    if (newScale > 5) return;
    
    img.style.transform = `scale(${newScale})`;
}

// Close generic modal
function closeModal(modalId) {
    const modal = document.getElementById(modalId);
    if (modal) modal.remove();
}

// Enhanced uploads display
function updateUploadsDisplay() {
    const uploadsTab = document.getElementById('uploads-tab');
    if (!uploadsTab) return;
    
    if (userState.uploads.length === 0) {
        uploadsTab.innerHTML = `
            <div class="empty-state">
                <i class="fas fa-cloud-upload-alt" style="font-size: 48px; color: var(--epic-light-purple); margin-bottom: 20px;"></i>
                <h3>No Uploads Yet</h3>
                <p>Upload training videos, documents, or images to get started.</p>
                <button class="btn btn-primary" onclick="document.getElementById('upload-resource-btn').click()">
                    <i class="fas fa-upload"></i> Upload Your First Resource
                </button>
            </div>
        `;
        return;
    }
    
    // Sort by most recent
    const sortedUploads = [...userState.uploads].sort((a, b) => 
        new Date(b.uploadedAt) - new Date(a.uploadedAt)
    );
    
    let html = `
        <div class="uploads-header">
            <h3>My Uploaded Resources (${sortedUploads.length})</h3>
            <div class="upload-filters">
                <select id="upload-sort" onchange="sortUploads(this.value)">
                    <option value="newest">Newest First</option>
                    <option value="oldest">Oldest First</option>
                    <option value="name">Name A-Z</option>
                    <option value="size">Size</option>
                </select>
                <select id="upload-filter" onchange="filterUploads(this.value)">
                    <option value="all">All Types</option>
                    <option value="video">Videos</option>
                    <option value="image">Images</option>
                    <option value="document">Documents</option>
                </select>
            </div>
        </div>
        <div class="resource-grid" id="uploads-grid">
    `;
    
    sortedUploads.forEach((upload, index) => {
        const mediaType = upload.type.split('/')[0];
        const fileIcon = mediaType === 'video' ? 'fa-file-video' :
                       mediaType === 'image' ? 'fa-file-image' :
                       upload.type.includes('pdf') ? 'fa-file-pdf' :
                       upload.type.includes('word') || upload.type.includes('document') ? 'fa-file-word' : 'fa-file';
        
        const isMedia = mediaType === 'video' || mediaType === 'image';
        const thumbnail = isMedia ? upload.base64Data : '';
        
        html += `
            <div class="resource-card upload-card" data-type="${mediaType}">
                <div class="upload-badge ${upload.public ? 'public' : 'private'}">
                    <i class="fas fa-${upload.public ? 'globe' : 'lock'}"></i>
                    ${upload.public ? 'Public' : 'Private'}
                </div>
                
                ${isMedia ? `
                    <div class="media-thumbnail" onclick="openMediaPlayer('${upload.id}')">
                        ${mediaType === 'video' ? 
                            `<div class="video-thumb">
                                <img src="https://img.icons8.com/color/96/000000/video-file.png" alt="Video">
                                <div class="play-button">
                                    <i class="fas fa-play"></i>
                                </div>
                            </div>` :
                            `<img src="${thumbnail}" alt="${upload.title}" class="image-thumb">`
                        }
                    </div>
                ` : `
                    <div class="file-icon" onclick="openMediaPlayer('${upload.id}')">
                        <i class="fas ${fileIcon}"></i>
                    </div>
                `}
                
                <h4 onclick="openMediaPlayer('${upload.id}')" style="cursor: pointer; margin: 10px 0;">
                    ${upload.title}
                </h4>
                
                <div class="upload-meta">
                    <span><i class="fas fa-file"></i> ${upload.category || 'File'}</span>
                    <span><i class="fas fa-hdd"></i> ${formatFileSize(upload.size)}</span>
                    <span><i class="fas fa-calendar"></i> ${new Date(upload.uploadedAt).toLocaleDateString()}</span>
                </div>
                
                <p class="upload-description">${upload.description || 'No description'}</p>
                
                <div class="upload-stats">
                    <span><i class="fas fa-eye"></i> ${upload.viewCount || 0}</span>
                    <span><i class="fas fa-download"></i> ${upload.downloadCount || 0}</span>
                </div>
                
                <div class="upload-actions">
                    <button onclick="openMediaPlayer('${upload.id}')" class="btn ${isMedia ? 'btn-primary' : 'btn-outline'}">
                        <i class="fas fa-${isMedia ? 'play' : 'eye'}"></i> ${isMedia ? 'Play' : 'View'}
                    </button>
                    <button onclick="downloadMedia('${upload.id}')" class="btn btn-outline">
                        <i class="fas fa-download"></i>
                    </button>
                </div>
            </div>
        `;
    });
    
    html += '</div>';
    uploadsTab.innerHTML = html;
}

// Sort uploads
function sortUploads(criteria) {
    const sorted = [...userState.uploads];
    
    switch(criteria) {
        case 'oldest':
            sorted.sort((a, b) => new Date(a.uploadedAt) - new Date(b.uploadedAt));
            break;
        case 'name':
            sorted.sort((a, b) => a.title.localeCompare(b.title));
            break;
        case 'size':
            sorted.sort((a, b) => b.size - a.size);
            break;
        default: // newest
            sorted.sort((a, b) => new Date(b.uploadedAt) - new Date(a.uploadedAt));
    }
    
    // Re-render
    const container = document.getElementById('uploads-grid');
    if (container) {
        // Just update the order in localStorage
        userState.uploads = sorted;
        saveToStorage();
        updateUploadsDisplay();
    }
}

// Filter uploads
function filterUploads(filter) {
    const cards = document.querySelectorAll('.upload-card');
    cards.forEach(card => {
        if (filter === 'all' || card.dataset.type === filter) {
            card.style.display = 'block';
        } else {
            card.style.display = 'none';
        }
    });
}

// Initialize upload system
document.addEventListener('DOMContentLoaded', function() {
    // Update upload button handler
    setTimeout(() => {
        const uploadBtn = document.getElementById('start-upload-btn');
        if (uploadBtn) {
            uploadBtn.onclick = handleRealFileUpload;
        }
        
        // Update file input to show preview
        const fileInput = document.getElementById('file-input');
        if (fileInput) {
            fileInput.addEventListener('change', function(e) {
                if (e.target.files.length > 0) {
                    const file = e.target.files[0];
                    const fileName = document.getElementById('file-name');
                    const fileSize = document.getElementById('file-size');
                    const fileInfo = document.getElementById('file-info');
                    
                    if (fileName) fileName.textContent = file.name;
                    if (fileSize) fileSize.textContent = formatFileSize(file.size);
                    if (fileInfo) fileInfo.style.display = 'block';
                    
                    // Show preview for images
                    if (file.type.startsWith('image/')) {
                        const reader = new FileReader();
                        reader.onload = function(e) {
                            const preview = document.createElement('img');
                            preview.src = e.target.result;
                            preview.style.maxWidth = '200px';
                            preview.style.maxHeight = '150px';
                            preview.style.marginTop = '10px';
                            preview.style.borderRadius = '5px';
                            
                            const existingPreview = fileInfo.querySelector('img');
                            if (existingPreview) existingPreview.remove();
                            fileInfo.appendChild(preview);
                        };
                        reader.readAsDataURL(file);
                    }
                }
            });
        }
    }, 1000);
});
</script>

<style>
/* Media Player Styles */
.video-player-container {
    position: relative;
    background: #000;
    border-radius: 8px;
    overflow: hidden;
    margin-bottom: 15px;
}

.video-controls {
    display: flex;
    gap: 10px;
    padding: 10px;
    background: rgba(0,0,0,0.8);
    justify-content: center;
}

.image-viewer-container {
    text-align: center;
    background: #f8f9fa;
    padding: 20px;
    border-radius: 8px;
    margin-bottom: 15px;
}

.image-controls {
    display: flex;
    gap: 10px;
    justify-content: center;
    margin-top: 10px;
}

.document-viewer {
    text-align: center;
    padding: 40px 20px;
    background: linear-gradient(135deg, #f8f9fa, #e9ecef);
    border-radius: 8px;
    margin-bottom: 15px;
}

.media-stats {
    display: flex;
    gap: 15px;
    margin-left: auto;
    margin-right: 15px;
}

.media-stats .stat {
    display: flex;
    align-items: center;
    gap: 5px;
    font-size: 14px;
    color: var(--dark-gray);
}

.details-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 15px;
    margin-top: 10px;
}

.detail {
    padding: 10px;
    background: white;
    border-radius: 5px;
    border: 1px solid var(--medium-gray);
}

.tags {
    display: flex;
    flex-wrap: wrap;
    gap: 5px;
    margin-top: 5px;
}

.tag {
    background: var(--epic-light-bg);
    color: var(--epic-purple);
    padding: 2px 8px;
    border-radius: 12px;
    font-size: 12px;
}

.badge {
    padding: 4px 8px;
    border-radius: 4px;
    font-size: 12px;
    font-weight: 600;
}

.badge.public {
    background: var(--success);
    color: white;
}

.badge.private {
    background: var(--dark-gray);
    color: white;
}

/* Uploads Display */
.uploads-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    flex-wrap: wrap;
    gap: 15px;
}

.upload-filters {
    display: flex;
    gap: 10px;
}

.upload-filters select {
    padding: 8px 12px;
    border: 2px solid var(--epic-light-purple);
    border-radius: 6px;
    background: white;
    font-size: 14px;
}

.upload-card {
    position: relative;
    transition: transform 0.3s ease;
}

.upload-card:hover {
    transform: translateY(-5px);
}

.media-thumbnail {
    position: relative;
    cursor: pointer;
    overflow: hidden;
    border-radius: 8px;
    margin-bottom: 10px;
    height: 150px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #f8f9fa;
}

.video-thumb {
    position: relative;
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
}

.video-thumb img {
    max-width: 80px;
    opacity: 0.7;
}

.play-button {
    position: absolute;
    width: 50px;
    height: 50px;
    background: rgba(75, 40, 109, 0.9);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 20px;
}

.image-thumb {
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.3s ease;
}

.image-thumb:hover {
    transform: scale(1.05);
}

.file-icon {
    text-align: center;
    padding: 30px;
    font-size: 48px;
    color: var(--epic-purple);
    cursor: pointer;
    background: var(--epic-light-bg);
    border-radius: 8px;
    margin-bottom: 10px;
}

.upload-meta {
    display: flex;
    justify-content: space-between;
    font-size: 12px;
    color: var(--dark-gray);
    margin: 10px 0;
    flex-wrap: wrap;
    gap: 8px;
}

.upload-description {
    font-size: 14px;
    color: var(--text-light);
    margin: 10px 0;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

.upload-stats {
    display: flex;
    gap: 15px;
    font-size: 12px;
    color: var(--dark-gray);
    margin: 10px 0;
}

.upload-actions {
    display: flex;
    gap: 8px;
    margin-top: 10px;
}

.upload-actions .btn {
    flex: 1;
    text-align: center;
}

.empty-state {
    text-align: center;
    padding: 60px 20px;
    color: var(--dark-gray);
}

.empty-state h3 {
    margin: 20px 0 10px;
    color: var(--epic-purple);
}

.empty-state p {
    margin-bottom: 20px;
}
</style>
MEDIAEOF

# Insert the new media system before the closing body tag
sed -i '' '/<\/body>/i\
<!-- COMPLETE MEDIA MANAGEMENT SYSTEM -->' index.html

# Add the media system content
sed -i '' '/<!-- COMPLETE MEDIA MANAGEMENT SYSTEM -->/r media-system.html' index.html

# Clean up temp files
rm -f media-system.html
rm -f index.html.backup.media

echo "✅ Complete media system installed!"
echo "🎬 Features added:"
echo "1. Real video/image playback"
echo "2. File upload with Base64 storage"
echo "3. Media player with controls"
echo "4. Download/Share functionality"
echo "5. View count tracking"
echo "6. Sort/Filter uploads"
echo "7. Thumbnail previews"
