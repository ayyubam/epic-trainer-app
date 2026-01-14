import re

with open('index.html', 'r') as f:
    content = f.read()

print("Looking for auto-executing media player calls...")

# Find all calls to openMediaPlayer, viewUploadedMedia, openAdvancedMediaViewer
patterns = [
    (r'openMediaPlayer\([^)]*\)', 'openMediaPlayer'),
    (r'viewUploadedMedia\([^)]*\)', 'viewUploadedMedia'),
    (r'openAdvancedMediaViewer\([^)]*\)', 'openAdvancedMediaViewer'),
]

lines = content.split('\n')
changes = []

for i, line in enumerate(lines):
    line_num = i + 1
    
    for pattern, func_name in patterns:
        if re.search(pattern, line):
            # Check if it's inside a function definition or event handler
            context_start = max(0, i - 10)
            context_end = min(len(lines), i + 10)
            context = '\n'.join(lines[context_start:context_end])
            
            # Skip if it's in a function definition
            if re.search(r'function\s+\w+', context):
                continue
            
            # Skip if it's in an onclick handler (that's OK)
            if 'onclick=' in context:
                continue
            
            # Skip if it's in a template literal (that's OK - it's a string)
            if '`' in context and line in context.split('`')[1]:
                continue
            
            # This is likely problematic - it's executing on page load
            print(f"Line {line_num}: Found {func_name} call that may auto-execute")
            print(f"  Context: {line.strip()[:100]}...")
            
            # Comment it out
            if not line.strip().startswith('//'):
                lines[i] = f"// TEMPORARILY DISABLED - WAS CAUSING PAGE LOAD ISSUES: {line}"
                changes.append(line_num)

if changes:
    print(f"\nCommented out {len(changes)} potentially problematic calls on lines: {changes}")
    
    with open('index.html.fixed_auto', 'w') as f:
        f.write('\n'.join(lines))
    
    print("Created index.html.fixed_auto")
else:
    print("\nNo problematic auto-executing calls found.")
    
    # Let me check for another issue - maybe the function itself is being output
    print("\nChecking if JavaScript functions are being rendered as HTML...")
    
    # Look for function definitions that might be outside script tags
    in_script = False
    for i, line in enumerate(lines):
        if '<script' in line and '</script>' not in line:
            in_script = True
        if '</script>' in line:
            in_script = False
        
        if not in_script and 'function ' in line:
            print(f"Line {i+1}: Function definition outside script tag!")
            print(f"  {line.strip()[:100]}...")
