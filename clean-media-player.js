// ==================== CLEAN MEDIA PLAYER SYSTEM ====================

// Global media player state
const mediaPlayer = {
    currentMedia: null,
    player: null
};

// Open media player with clean DOM manipulation
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
    
    // Create modal element
    const modal = document.createElement('div');
    modal.id = 'media-player-modal';
    modal.className = 'modal-overlay active';
    modal.style.position = 'fixed';
    modal.style.top = '0';
    modal.style.left = '0';
    modal.style.right = '0';
    modal.style.bottom = '0';
    modal.style.background = 'rgba(0,0,0,0.7)';
    modal.style.zIndex = '10002';
    modal.style.display = 'flex';
    modal.style.alignItems = 'center';
    modal.style.justifyContent = 'center';
    
    const mediaType = upload.type.split('/')[0];
    
    // Create player content based on file type
    let playerContent = '';
    if (mediaType === 'video') {
        playerContent = `
            <div class="video-player-container">
                <video id="media-player-element" controls autoplay style="width: 100%; max-height: 60vh; border-radius: 8px;">
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
                </div>
            </div>
        `;
    } else if (mediaType === 'image') {
        playerContent = `
            <div class="image-viewer-container">
                <img src="${upload.base64Data}" id="media-image-element" 
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
        playerContent = `
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
    
    modal.innerHTML = `
        <div class="modal" style="background: white; border-radius: 12px; max-width: 90%; max-height: 90vh; width: 800px; display: flex; flex-direction: column;">
            <div class="modal-header" style="display: flex; justify-content: space-between; align-items: center; padding: 20px; border-bottom: 1px solid #dee2e6;">
                <h2 style="margin: 0; display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-${mediaType === 'video' ? 'play-circle' : mediaType === 'image' ? 'image' : 'file'}"></i> 
                    ${upload.title}
                </h2>
                <button onclick="closeMediaPlayer()" style="background: none; border: none; font-size: 24px; cursor: pointer; color: #6c757d;">&times;</button>
            </div>
            
            <div class="modal-body" style="flex: 1; padding: 20px; overflow-y: auto;">
                ${playerContent}
                
                <div style="margin-top: 20px; padding-top: 20px; border-top: 1px solid #dee2e6;">
                    <h4 style="margin-bottom: 10px;"><i class="fas fa-info-circle"></i> File Details</h4>
                    <p><strong>Description:</strong> ${upload.description || 'No description provided.'}</p>
                    <p><strong>Category:</strong> ${upload.category || 'Uncategorized'}</p>
                    <p><strong>Uploaded:</strong> ${new Date(upload.uploadedAt).toLocaleString()}</p>
                    <p><strong>Size:</strong> ${formatFileSize(upload.size)}</p>
                </div>
                
                <div style="margin-top: 20px; display: flex; gap: 10px; flex-wrap: wrap;">
                    <button onclick="downloadMedia('${upload.id}')" class="btn btn-primary">
                        <i class="fas fa-download"></i> Download File
                    </button>
                    <button onclick="shareMedia('${upload.id}')" class="btn btn-outline">
                        <i class="fas fa-share"></i> Share
                    </button>
                    <button onclick="closeMediaPlayer()" class="btn btn-outline">
                        Close
                    </button>
                </div>
            </div>
        </div>
    `;
    
    // Remove existing modal if any
    closeMediaPlayer();
    
    // Add to page
    document.body.appendChild(modal);
    
    // Initialize player
    if (mediaType === 'video') {
        const video = document.getElementById('media-player-element');
        if (video) {
            mediaPlayer.player = video;
            video.play().catch(e => console.log('Auto-play prevented:', e));
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
    if (modal) {
        modal.remove();
    }
}

// Download media
function downloadMedia(uploadId) {
    const upload = userState.uploads.find(u => u.id === uploadId);
    if (!upload) {
        showNotification('File not found', 'error');
        return;
    }
    
    upload.downloadCount = (upload.downloadCount || 0) + 1;
    saveToStorage();
    
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
    const shareText = `${upload.title}\n\n${upload.description || 'Check out this Epic resource'}\n\nView online: ${shareUrl}`;
    
    if (navigator.share) {
        navigator.share({
            title: upload.title,
            text: upload.description || 'Check out this Epic resource',
            url: shareUrl
        }).catch(err => {
            console.log('Share cancelled:', err);
        });
    } else {
        navigator.clipboard.writeText(shareText).then(() => {
            showNotification('Link copied to clipboard!', 'success');
        }).catch(err => {
            // Fallback for older browsers
            const textArea = document.createElement('textarea');
            textArea.value = shareText;
            document.body.appendChild(textArea);
            textArea.select();
            document.execCommand('copy');
            document.body.removeChild(textArea);
            showNotification('Link copied to clipboard!', 'success');
        });
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
        } else if (video.mozRequestFullScreen) {
            video.mozRequestFullScreen();
        } else if (video.msRequestFullscreen) {
            video.msRequestFullscreen();
        }
    } else {
        if (document.exitFullscreen) {
            document.exitFullscreen();
        } else if (document.webkitExitFullscreen) {
            document.webkitExitFullscreen();
        } else if (document.mozCancelFullScreen) {
            document.mozCancelFullScreen();
        } else if (document.msExitFullscreen) {
            document.msExitFullscreen();
        }
    }
}

// Zoom image
function zoomImage(factor) {
    const img = document.getElementById('media-image-element');
    if (!img) return;
    
    const currentScale = parseFloat(img.style.transform.replace('scale(', '').replace(')', '')) || 1;
    const newScale = currentScale * factor;
    
    if (newScale < 0.1 || newScale > 5) return;
    
    img.style.transform = `scale(${newScale})`;
    img.style.transition = 'transform 0.3s ease';
}

// Enhanced uploads display with working buttons
function updateUploadsDisplay() {
    const uploadsTab = document.getElementById('uploads-tab');
    if (!uploadsTab) return;
    
    if (userState.uploads.length === 0) {
        uploadsTab.innerHTML = `
            <div style="text-align: center; padding: 60px 20px;">
                <i class="fas fa-cloud-upload-alt" style="font-size: 48px; color: #7B52AB; margin-bottom: 20px;"></i>
                <h3 style="color: #4B286D;">No Uploads Yet</h3>
                <p style="color: #6c757d; margin-bottom: 20px;">Upload training videos, documents, or images to get started.</p>
                <button class="btn btn-primary" onclick="document.getElementById('upload-resource-btn')?.click()">
                    <i class="fas fa-upload"></i> Upload Your First Resource
                </button>
            </div>
        `;
        return;
    }
    
    let html = `
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; flex-wrap: wrap; gap: 15px;">
            <h3>My Uploaded Resources (${userState.uploads.length})</h3>
        </div>
        <div class="resource-grid">
    `;
    
    userState.uploads.forEach(upload => {
        const mediaType = upload.type.split('/')[0];
        const fileIcon = mediaType === 'video' ? 'fa-file-video' :
                       mediaType === 'image' ? 'fa-file-image' :
                       upload.type.includes('pdf') ? 'fa-file-pdf' :
                       upload.type.includes('word') ? 'fa-file-word' : 'fa-file';
        
        const isMedia = mediaType === 'video' || mediaType === 'image';
        
        html += `
            <div class="resource-card" style="position: relative;">
                <div style="position: absolute; top: 10px; right: 10px; background: ${upload.public ? '#28a745' : '#6c757d'}; color: white; padding: 4px 8px; border-radius: 4px; font-size: 12px;">
                    <i class="fas fa-${upload.public ? 'globe' : 'lock'}"></i>
                    ${upload.public ? 'Public' : 'Private'}
                </div>
                
                ${isMedia ? `
                    <div style="height: 150px; overflow: hidden; border-radius: 8px; margin-bottom: 10px; background: #f8f9fa; display: flex; align-items: center; justify-content: center; cursor: pointer;" onclick="openMediaPlayer('${upload.id}')">
                        ${mediaType === 'video' ? 
                            `<div style="text-align: center;">
                                <i class="fas fa-play-circle" style="font-size: 48px; color: #4B286D;"></i>
                                <p style="margin-top: 10px; font-size: 14px;">Click to play video</p>
                            </div>` :
                            `<img src="${upload.base64Data}" alt="${upload.title}" style="width: 100%; height: 100%; object-fit: cover;">`
                        }
                    </div>
                ` : `
                    <div style="text-align: center; padding: 30px; background: #F8F6FC; border-radius: 8px; margin-bottom: 10px; cursor: pointer;" onclick="openMediaPlayer('${upload.id}')">
                        <i class="fas ${fileIcon}" style="font-size: 48px; color: #4B286D;"></i>
                    </div>
                `}
                
                <h4 style="margin: 10px 0; color: #4B286D; cursor: pointer;" onclick="openMediaPlayer('${upload.id}')">
                    ${upload.title}
                </h4>
                
                <div style="display: flex; justify-content: space-between; font-size: 12px; color: #6c757d; margin: 10px 0;">
                    <span>${upload.category || 'File'}</span>
                    <span>${formatFileSize(upload.size)}</span>
                </div>
                
                <p style="font-size: 14px; color: #495057; margin: 10px 0; min-height: 40px;">
                    ${upload.description || 'No description provided.'}
                </p>
                
                <div style="display: flex; gap: 10px; margin-top: 15px;">
                    <button onclick="openMediaPlayer('${upload.id}')" class="btn ${isMedia ? 'btn-primary' : 'btn-outline'}" style="flex: 1;">
                        <i class="fas fa-${isMedia ? 'play' : 'eye'}"></i> ${isMedia ? 'Play' : 'View'}
                    </button>
                    <button onclick="downloadMedia('${upload.id}')" class="btn btn-outline" style="flex: 1;">
                        <i class="fas fa-download"></i> Download
                    </button>
                </div>
            </div>
        `;
    });
    
    html += '</div>';
    uploadsTab.innerHTML = html;
}
