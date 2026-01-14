import re
import sys

filename = 'index.html'
backup = filename + '.backup'

# Create backup
import shutil
shutil.copy2(filename, backup)

with open(filename, 'r') as f:
    content = f.read()

# Find all JavaScript sections with template literals
# Look for patterns like: html += `...${upload.title}...`
js_sections = re.findall(r'(html\s*\+=\s*`[^`]*`)', content)

print(f"Found {len(js_sections)} JavaScript template sections")

# Fix common patterns
fixes = [
    # Fix: `...${upload.title}` (already correct)
    # Fix: " + upload.title + " inside backticks
    (r'`([^`]*)"\s*\+\s*upload\.(\w+)\s*\+\s*"([^`]*)`', 
     r'`\1${upload.\2}\3`'),
    
    # Fix: " + (upload.description || "") + "
    (r'`([^`]*)"\s*\+\s*\(\s*upload\.(\w+)\s*\|\|\s*"([^"]*)"\s*\)\s*\+\s*"([^`]*)`',
     r'`\1${upload.\2 || "\3"}\4`'),
]

for pattern, replacement in fixes:
    content = re.sub(pattern, replacement, content, flags=re.DOTALL)

# Save fixed file
with open(filename, 'w') as f:
    f.write(content)

print(f"Fixed {filename}. Original saved as {backup}")
print("Checking for remaining issues...")

# Check for remaining problems
problems = re.findall(r'"\s*\+\s*upload\.', content)
if problems:
    print(f"Found {len(problems)} remaining issues")
    for i, problem in enumerate(problems[:10], 1):
        print(f"  {i}. {problem}")
else:
    print("No remaining syntax issues found!")
