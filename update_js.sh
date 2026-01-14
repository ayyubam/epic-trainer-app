#!/bin/bash
# Find and replace the upload/download section in index.html

# Create a temporary file with the new JavaScript functions
cat > /tmp/new_js_functions.js << 'JSFUNCTIONS'
// ==================== ACTUAL UPLOAD/DOWNLOAD FUNCTIONS ====================

// Upload resource function
async function uploadFile(file, metadata) {
    showNotification('Uploading file...', 'info');
    
    try {
        const reader = new FileReader();
        
        return new Promise((resolve, reject) => {
            reader.onload = async function(e) {
                try {
                    const base64Content = e.target.result.split(',')[1];
                    
                    const response = await fetch('/.netlify/functions/upload', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        body: JSON.stringify({
                            filename: metadata.filename || file.name,
                            content: base64Content,
                            category: metadata.category || 'resource',
                            title: metadata.title || file.name,
                            description: metadata.description || '',
                            tags: metadata.tags || []
                        })
                    });
                    
                    const result = await response.json();
                    
                    if (result.success) {
                        showNotification('File uploaded successfully!', 'success');
                        resolve(result);
                    } else {
                        showNotification('Upload failed: ' + result.error, 'error');
                        reject(result);
                    }
                } catch (error) {
                    showNotification('Upload error: ' + error.message, 'error');
                    reject(error);
                }
            };
            
            reader.onerror = function(error) {
                showNotification('Error reading file: ' + error, 'error');
                reject(error);
            };
            
            reader.readAsDataURL(file);
        });
    } catch (error) {
        showNotification('Upload failed: ' + error.message, 'error');
        throw error;
    }
}

// Download file function
async function downloadFile(filename) {
    try {
        showNotification('Preparing download...', 'info');
        
        const response = await fetch(\`/.netlify/functions/download?filename=\${encodeURIComponent(filename)}\`);
        
        if (!response.ok) {
            throw new Error('Download failed');
        }
        
        const blob = await response.blob();
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = filename;
        document.body.appendChild(a);
        a.click();
        window.URL.revokeObjectURL(url);
        document.body.removeChild(a);
        
        showNotification('Download started!', 'success');
    } catch (error) {
        showNotification('Download failed: ' + error.message, 'error');
    }
}

// List all files
async function listFiles() {
    try {
        const response = await fetch('/.netlify/functions/list-files');
        const result = await response.json();
        
        if (result.success) {
            return result.files;
        }
        return [];
    } catch (error) {
        console.error('Error listing files:', error);
        return [];
    }
}

// Upload hospital data
async function uploadHospitalData(data) {
    try {
        const response = await fetch('/.netlify/functions/upload', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                filename: \`hospital-data-\${Date.now()}.json\`,
                content: btoa(JSON.stringify(data, null, 2)),
                category: 'hospital-data'
            })
        });
        
        const result = await response.json();
        
        if (result.success) {
            showNotification('Hospital data uploaded successfully!', 'success');
            return result;
        } else {
            showNotification('Upload failed: ' + result.error, 'error');
            return null;
        }
    } catch (error) {
        showNotification('Upload error: ' + error.message, 'error');
        return null;
    }
}

// Export all hospitals as JSON
function exportAllHospitals() {
    try {
        const dataStr = JSON.stringify(hospitals, null, 2);
        const dataBlob = new Blob([dataStr], { type: 'application/json' });
        const url = window.URL.createObjectURL(dataBlob);
        const a = document.createElement('a');
        a.href = url;
        a.download = \`epic-hospitals-\${new Date().toISOString().split('T')[0]}.json\`;
        document.body.appendChild(a);
        a.click();
        window.URL.revokeObjectURL(url);
        document.body.removeChild(a);
        
        showNotification('Hospital database exported!', 'success');
    } catch (error) {
        showNotification('Export failed: ' + error.message, 'error');
    }
}

// Download hospital template
function showHospitalTemplate() {
    const template = {
        name: "Hospital Name",
        version: "Epic 2023",
        modules: ["Module1", "Module2"],
        notes: "Hospital description",
        goLiveDate: "2024-01-01",
        epicTeamSize: 50,
        trainingRooms: 10,
        supportModel: "24/7 Support",
        specialtyAreas: ["Cardiology", "Oncology"],
        contact: {
            name: "Contact Person",
            email: "contact@hospital.org",
            phone: "(555) 123-4567",
            role: "Epic Lead"
        },
        stats: {
            usersTrained: 1000,
            goLiveSuccess: 95,
            supportTickets: 50,
            avgResolutionTime: "2 hours"
        }
    };
    
    const dataStr = JSON.stringify(template, null, 2);
    const dataBlob = new Blob([dataStr], { type: 'application/json' });
    const url = window.URL.createObjectURL(dataBlob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'hospital-template.json';
    document.body.appendChild(a);
    a.click();
    window.URL.revokeObjectURL(url);
    document.body.removeChild(a);
    
    showNotification('Hospital template downloaded!', 'success');
}

// Video player functionality
function playVideo(videoUrl) {
    // Create video modal
    const videoModal = document.createElement('div');
    videoModal.className = 'video-modal';
    videoModal.innerHTML = \`
        <div class="video-modal-content">
            <button class="close-video">&times;</button>
            <video controls autoplay style="width: 100%; max-width: 800px;">
                <source src="\${videoUrl}" type="video/mp4">
                Your browser does not support the video tag.
            </video>
        </div>
    \`;
    
    document.body.appendChild(videoModal);
    videoModal.style.cssText = \`
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(0,0,0,0.8);
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 10000;
    \`;
    
    videoModal.querySelector('.close-video').onclick = () => {
        document.body.removeChild(videoModal);
    };
}

// Initialize file upload handling
function initFileUpload() {
    const fileInput = document.getElementById('file-input');
    const startUploadBtn = document.getElementById('start-upload-btn');
    
    if (fileInput && startUploadBtn) {
        fileInput.addEventListener('change', (e) => {
            if (e.target.files.length > 0) {
                startUploadBtn.disabled = false;
            }
        });
        
        startUploadBtn.addEventListener('click', async () => {
            if (fileInput.files.length === 0) {
                showNotification('Please select a file first', 'warning');
                return;
            }
            
            const file = fileInput.files[0];
            const title = document.getElementById('doc-title').value || file.name;
            const description = document.getElementById('doc-description').value || '';
            const category = document.getElementById('doc-category').value || 'resource';
            
            try {
                startUploadBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Uploading...';
                startUploadBtn.disabled = true;
                
                await uploadFile(file, {
                    filename: file.name,
                    title: title,
                    description: description,
                    category: category
                });
                
                // Reset form
                fileInput.value = '';
                document.getElementById('doc-title').value = '';
                document.getElementById('doc-description').value = '';
                document.getElementById('file-info').style.display = 'none';
                document.getElementById('upload-modal').classList.remove('active');
                
                startUploadBtn.innerHTML = '<i class="fas fa-upload"></i> Upload Document';
                startUploadBtn.disabled = false;
            } catch (error) {
                startUploadBtn.innerHTML = '<i class="fas fa-upload"></i> Upload Document';
                startUploadBtn.disabled = false;
            }
        });
    }
}

// ==================== END ACTUAL UPLOAD/DOWNLOAD FUNCTIONS ====================
JSFUNCTIONS

# Now update the index.html file
# Find the old upload/download functions section and replace it
sed -i '/\/\/ ==================== SECTION UPLOAD\/DOWNLOAD FUNCTIONS ====================/,/\/\/ ==================== END UPLOAD\/DOWNLOAD FUNCTIONS ====================/c\
// ==================== ACTUAL UPLOAD/DOWNLOAD FUNCTIONS ====================\
\
// Upload resource function\
async function uploadFile(file, metadata) {\
    showNotification(\"Uploading file...\", \"info\");\
    \
    try {\
        const reader = new FileReader();\
        \
        return new Promise((resolve, reject) => {\
            reader.onload = async function(e) {\
                try {\
                    const base64Content = e.target.result.split(\",\")[1];\
                    \
                    const response = await fetch(\"/.netlify/functions/upload\", {\
                        method: \"POST\",\
                        headers: {\
                            \"Content-Type\": \"application/json\",\
                        },\
                        body: JSON.stringify({\
                            filename: metadata.filename || file.name,\
                            content: base64Content,\
                            category: metadata.category || \"resource\",\
                            title: metadata.title || file.name,\
                            description: metadata.description || \"\",\
                            tags: metadata.tags || []\
                        })\
                    });\
                    \
                    const result = await response.json();\
                    \
                    if (result.success) {\
                        showNotification(\"File uploaded successfully!\", \"success\");\
                        resolve(result);\
                    } else {\
                        showNotification(\"Upload failed: \" + result.error, \"error\");\
                        reject(result);\
                    }\
                } catch (error) {\
                    showNotification(\"Upload error: \" + error.message, \"error\");\
                    reject(error);\
                }\
            };\
            \
            reader.onerror = function(error) {\
                showNotification(\"Error reading file: \" + error, \"error\");\
                reject(error);\
            };\
            \
            reader.readAsDataURL(file);\
        });\
    } catch (error) {\
        showNotification(\"Upload failed: \" + error.message, \"error\");\
        throw error;\
    }\
}\
\
// Download file function\
async function downloadFile(filename) {\
    try {\
        showNotification(\"Preparing download...\", \"info\");\
        \
        const response = await fetch(\`/.netlify/functions/download?filename=\${encodeURIComponent(filename)}\`);\
        \
        if (!response.ok) {\
            throw new Error(\"Download failed\");\
        }\
        \
        const blob = await response.blob();\
        const url = window.URL.createObjectURL(blob);\
        const a = document.createElement(\"a\");\
        a.href = url;\
        a.download = filename;\
        document.body.appendChild(a);\
        a.click();\
        window.URL.revokeObjectURL(url);\
        document.body.removeChild(a);\
        \
        showNotification(\"Download started!\", \"success\");\
    } catch (error) {\
        showNotification(\"Download failed: \" + error.message, \"error\");\
    }\
}\
\
// List all files\
async function listFiles() {\
    try {\
        const response = await fetch(\"/.netlify/functions/list-files\");\
        const result = await response.json();\
        \
        if (result.success) {\
            return result.files;\
        }\
        return [];\
    } catch (error) {\
        console.error(\"Error listing files:\", error);\
        return [];\
    }\
}\
\
// Upload hospital data\
async function uploadHospitalData(data) {\
    try {\
        const response = await fetch(\"/.netlify/functions/upload\", {\
            method: \"POST\",\
            headers: {\
                \"Content-Type\": \"application/json\",\
            },\
            body: JSON.stringify({\
                filename: \`hospital-data-\${Date.now()}.json\`,\
                content: btoa(JSON.stringify(data, null, 2)),\
                category: \"hospital-data\"\
            })\
        });\
        \
        const result = await response.json();\
        \
        if (result.success) {\
            showNotification(\"Hospital data uploaded successfully!\", \"success\");\
            return result;\
        } else {\
            showNotification(\"Upload failed: \" + result.error, \"error\");\
            return null;\
        }\
    } catch (error) {\
        showNotification(\"Upload error: \" + error.message, \"error\");\
        return null;\
    }\
}\
\
// Export all hospitals as JSON\
function exportAllHospitals() {\
    try {\
        const dataStr = JSON.stringify(hospitals, null, 2);\
        const dataBlob = new Blob([dataStr], { type: \"application/json\" });\
        const url = window.URL.createObjectURL(dataBlob);\
        const a = document.createElement(\"a\");\
        a.href = url;\
        a.download = \`epic-hospitals-\${new Date().toISOString().split(\"T\")[0]}.json\`;\
        document.body.appendChild(a);\
        a.click();\
        window.URL.revokeObjectURL(url);\
        document.body.removeChild(a);\
        \
        showNotification(\"Hospital database exported!\", \"success\");\
    } catch (error) {\
        showNotification(\"Export failed: \" + error.message, \"error\");\
    }\
}\
\
// Download hospital template\
function showHospitalTemplate() {\
    const template = {\
        name: \"Hospital Name\",\
        version: \"Epic 2023\",\
        modules: [\"Module1\", \"Module2\"],\
        notes: \"Hospital description\",\
        goLiveDate: \"2024-01-01\",\
        epicTeamSize: 50,\
        trainingRooms: 10,\
        supportModel: \"24/7 Support\",\
        specialtyAreas: [\"Cardiology\", \"Oncology\"],\
        contact: {\
            name: \"Contact Person\",\
            email: \"contact@hospital.org\",\
            phone: \"(555) 123-4567\",\
            role: \"Epic Lead\"\
        },\
        stats: {\
            usersTrained: 1000,\
            goLiveSuccess: 95,\
            supportTickets: 50,\
            avgResolutionTime: \"2 hours\"\
        }\
    };\
    \
    const dataStr = JSON.stringify(template, null, 2);\
    const dataBlob = new Blob([dataStr], { type: \"application/json\" });\
    const url = window.URL.createObjectURL(dataBlob);\
    const a = document.createElement(\"a\");\
    a.href = url;\
    a.download = \"hospital-template.json\";\
    document.body.appendChild(a);\
    a.click();\
    window.URL.revokeObjectURL(url);\
    document.body.removeChild(a);\
    \
    showNotification(\"Hospital template downloaded!\", \"success\");\
}\
\
// Video player functionality\
function playVideo(videoUrl) {\
    // Create video modal\
    const videoModal = document.createElement(\"div\");\
    videoModal.className = \"video-modal\";\
    videoModal.innerHTML = \`\
        <div class=\"video-modal-content\">\
            <button class=\"close-video\">&times;</button>\
            <video controls autoplay style=\"width: 100%; max-width: 800px;\">\
                <source src=\"\${videoUrl}\" type=\"video/mp4\">\
                Your browser does not support the video tag.\
            </video>\
        </div>\
    \`;\
    \
    document.body.appendChild(videoModal);\
    videoModal.style.cssText = \`\
        position: fixed;\
        top: 0;\
        left: 0;\
        right: 0;\
        bottom: 0;\
        background: rgba(0,0,0,0.8);\
        display: flex;\
        align-items: center;\
        justify-content: center;\
        z-index: 10000;\
    \`;\
    \
    videoModal.querySelector(\".close-video\").onclick = () => {\
        document.body.removeChild(videoModal);\
    };\
}\
\
// Initialize file upload handling\
function initFileUpload() {\
    const fileInput = document.getElementById(\"file-input\");\
    const startUploadBtn = document.getElementById(\"start-upload-btn\");\
    \
    if (fileInput && startUploadBtn) {\
        fileInput.addEventListener(\"change\", (e) => {\
            if (e.target.files.length > 0) {\
                startUploadBtn.disabled = false;\
            }\
        });\
        \
        startUploadBtn.addEventListener(\"click\", async () => {\
            if (fileInput.files.length === 0) {\
                showNotification(\"Please select a file first\", \"warning\");\
                return;\
            }\
            \
            const file = fileInput.files[0];\
            const title = document.getElementById(\"doc-title\").value || file.name;\
            const description = document.getElementById(\"doc-description\").value || \"\";\
            const category = document.getElementById(\"doc-category\").value || \"resource\";\
            \
            try {\
                startUploadBtn.innerHTML = \"<i class=\\\"fas fa-spinner fa-spin\\\"></i> Uploading...\";\
                startUploadBtn.disabled = true;\
                \
                await uploadFile(file, {\
                    filename: file.name,\
                    title: title,\
                    description: description,\
                    category: category\
                });\
                \
                // Reset form\
                fileInput.value = \"\";\
                document.getElementById(\"doc-title\").value = \"\";\
                document.getElementById(\"doc-description\").value = \"\";\
                document.getElementById(\"file-info\").style.display = \"none\";\
                document.getElementById(\"upload-modal\").classList.remove(\"active\");\
                \
                startUploadBtn.innerHTML = \"<i class=\\\"fas fa-upload\\\"></i> Upload Document\";\
                startUploadBtn.disabled = false;\
            } catch (error) {\
                startUploadBtn.innerHTML = \"<i class=\\\"fas fa-upload\\\"></i> Upload Document\";\
                startUploadBtn.disabled = false;\
            }\
        });\
    }\
}\
\
// ==================== END ACTUAL UPLOAD/DOWNLOAD FUNCTIONS ====================' public/index.html

echo "JavaScript functions updated successfully!"
