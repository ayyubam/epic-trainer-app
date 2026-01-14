const fs = require('fs');
const path = require('path');

exports.handler = async (event) => {
  try {
    const uploadDir = path.join(process.cwd(), 'uploads');
    const resourceDir = path.join(process.cwd(), 'resources');
    
    let files = [];
    
    // Read uploads directory
    if (fs.existsSync(uploadDir)) {
      const uploadFiles = fs.readdirSync(uploadDir).map(file => ({
        name: file,
        path: `/uploads/${file}`,
        type: 'upload',
        size: fs.statSync(path.join(uploadDir, file)).size,
        uploaded: fs.statSync(path.join(uploadDir, file)).mtime
      }));
      files = files.concat(uploadFiles);
    }
    
    // Read resources directory
    if (fs.existsSync(resourceDir)) {
      const resourceFiles = fs.readdirSync(resourceDir).map(file => ({
        name: file,
        path: `/resources/${file}`,
        type: 'resource',
        size: fs.statSync(path.join(resourceDir, file)).size
      }));
      files = files.concat(resourceFiles);
    }
    
    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*'
      },
      body: JSON.stringify({ 
        success: true,
        files: files
      })
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({ 
        error: 'Failed to list files',
        message: error.message 
      })
    };
  }
};
