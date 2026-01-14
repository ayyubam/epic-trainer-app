import re
import html

with open('index.html', 'r') as f:
    content = f.read()

# Backup
with open('index.html.backup4', 'w') as f:
    f.write(content)

print("Looking for template literals that might be rendered as HTML...")

# Look for template literals that might be in HTML context (not in script tags)
lines = content.split('\n')
in_script = False
fixed_lines = []

for i, line in enumerate(lines):
    line_num = i + 1
    
    # Track script tags
    if '<script' in line and '</script>' not in line:
        in_script = True
    if '</script>' in line:
        in_script = False
    
    # If NOT in script tag and contains ${...}, it's a problem!
    if not in_script and '${' in line:
        print(f"Line {line_num}: Found template literal outside script tag")
        print(f"  Content: {line[:100]}...")
        # Escape the ${ so it doesn't get evaluated
        line = line.replace('${', '\\${')
    
    fixed_lines.append(line)

# Write fixed version
with open('index.html.fixed2', 'w') as f:
    f.write('\n'.join(fixed_lines))

print("\nCreated index.html.fixed2 with escaped template literals")
print("Use this file: mv index.html.fixed2 index.html")
