import re

with open('index.html', 'r') as f:
    content = f.read()

# Find lines that call media viewer functions outside of event handlers
problem_lines = []
lines = content.split('\n')

for i, line in enumerate(lines):
    line_num = i + 1
    # Look for problematic calls
    if re.search(r'\b(?:viewUploadedMedia|openAdvancedMediaViewer|openMediaPlayer)\s*\(', line):
        # Check if it's inside a function definition
        context = '\n'.join(lines[max(0, i-10):min(len(lines), i+10)])
        if not re.search(r'function\s+\w+.*\{[^}]*\n.*' + re.escape(line), context, re.DOTALL):
            if not re.search(r'=\s*function', context):
                if not re.search(r'addEventListener.*\{[^}]*\n.*' + re.escape(line), context, re.DOTALL):
                    if not re.search(r'onclick=.*' + re.escape(line), context):
                        problem_lines.append((line_num, line.strip()))

if problem_lines:
    print(f"Found {len(problem_lines)} potentially problematic calls:")
    for line_num, line in problem_lines:
        print(f"Line {line_num}: {line}")
        
    # Create fixed version by commenting out or wrapping these calls
    for line_num, line in problem_lines:
        idx = line_num - 1
        # Wrap in DOMContentLoaded or comment out
        if not lines[idx].strip().startswith('//'):
            # Check if it's inside a template literal
            if '`' not in line:
                lines[idx] = f"// FIXED: {lines[idx]} // Temporarily disabled - was causing page load issues"
    
    with open('index.html.fixed', 'w') as f:
        f.write('\n'.join(lines))
    
    print("\nCreated index.html.fixed with problematic calls commented out")
else:
    print("No problematic auto-executing calls found")
