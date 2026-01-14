const fs = require('fs');
const path = require('path');

exports.handler = async (event) => {
  try {
    const { filename } = event.queryStringParameters;
    
    if (!filename) {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: 'Filename is required' })
      };
    }
    
    // Check uploads directory first
    let filePath = path.join(process.cwd(), 'uploads', filename);
    
    // If not in uploads, check resources
    if (!fs.existsSync(filePath)) {
      filePath = path.join(process.cwd(), 'resources', filename);
    }
    
    if (!fs.existsSync(filePath)) {
      return {
        statusCode: 404,
        body: JSON.stringify({ error: 'File not found' })
      };
    }
    
    const fileContent = fs.readFileSync(filePath);
    const fileStats = fs.statSync(filePath);
    
    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/octet-stream',
        'Content-Disposition': \`attachment; filename="\${filename}"\`,
        'Content-Length': fileStats.size,
        'Access-Control-Allow-Origin': '*'
      },
      body: fileContent.toString('base64'),
      isBase64Encoded: true
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({ 
        error: 'Download failed',
        message: error.message 
      })
    };
  }
};
