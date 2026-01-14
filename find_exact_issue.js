const fs = require('fs');
const content = fs.readFileSync('index.html', 'utf8');

// Look for the pattern from your screenshot
const pattern = /\\\$\{upload\\.title\}.*?renderMediaContent/s;

const match = content.match(pattern);
if (match) {
    console.log("FOUND THE EXACT PROBLEM:");
    console.log("Match length:", match[0].length);
    console.log("First 200 chars:", match[0].substring(0, 200));
    
    // Find the position
    const pos = content.indexOf(match[0]);
    
    // Get context
    const start = Math.max(0, pos - 100);
    const end = Math.min(content.length, pos + match[0].length + 100);
    const context = content.substring(start, end);
    
    console.log("\n=== CONTEXT ===");
    console.log(context);
    
    // Check if it's in a script tag
    const before = content.substring(0, pos);
    const lastScriptOpen = before.lastIndexOf('<script');
    const lastScriptClose = before.lastIndexOf('</script>');
    
    console.log("\n=== SCRIPT TAG CHECK ===");
    console.log("Last <script tag before:", lastScriptOpen);
    console.log("Last </script> before:", lastScriptClose);
    
    if (lastScriptOpen > lastScriptClose) {
        console.log("✓ Inside a <script> tag");
    } else {
        console.log("✗ OUTSIDE <script> tags!");
        console.log("This JavaScript code is being rendered as HTML text.");
    }
} else {
    console.log("Pattern not found. Trying alternative patterns...");
    
    // Try without escapes
    const pattern2 = /\$\{upload\.title\}.*?renderMediaContent/s;
    const match2 = content.match(pattern2);
    if (match2) {
        console.log("\nFound pattern without escapes:");
        console.log(match2[0].substring(0, 200));
    }
    
    // Search for renderMediaContent function calls
    const lines = content.split('\n');
    for (let i = 0; i < lines.length; i++) {
        if (lines[i].includes('renderMediaContent')) {
            console.log(`\nLine ${i + 1}: ${lines[i].trim()}`);
        }
    }
}
