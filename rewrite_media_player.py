import re

with open('index.html', 'r') as f:
    content = f.read()

print("Rewriting openMediaPlayer function to prevent auto-execution...")

# Find the openMediaPlayer function
pattern = r'(function openMediaPlayer\(uploadId\) \{.*?\n\})'
match = re.search(pattern, content, re.DOTALL)

if match:
    func_content = match.group(0)
    print(f"Found openMediaPlayer function ({len(func_content)} chars)")
    
    # Check if it contains immediate execution
    if 'openMediaPlayer(' in func_content:
        print("⚠️ Function contains self-referential call")
    
    # Replace with a safer version that won't auto-execute
    # Actually, let's just make sure it's only called from event handlers
    
    # Instead, let's add a guard to prevent auto-execution
    new_func = func_content.replace(
        'function openMediaPlayer(uploadId) {',
        '''function openMediaPlayer(uploadId) {
    // Guard against undefined uploadId
    if (!uploadId) {
        console.error('openMediaPlayer called without uploadId');
        return;
    }
    
    // Prevent execution during page load
    if (typeof document === 'undefined' || !document.body) {
        console.warn('openMediaPlayer called before DOM ready');
        return;
    }'''
    )
    
    # Replace in content
    content = content.replace(func_content, new_func)
    
    with open('index.html.rewritten', 'w') as f:
        f.write(content)
    
    print("Created index.html.rewritten with safer openMediaPlayer function")
else:
    print("Could not find openMediaPlayer function")
