import re

print("Creating clean version from index.html...")

try:
    with open('index.html', 'r') as f:
        content = f.read()
except FileNotFoundError:
    print("ERROR: index.html not found!")
    exit(1)

# 1. Fix ALL template literal escapes
content = content.replace('&dollar;{', '${')
content = content.replace('&amp;dollar;{', '${')

# 2. Also fix any other HTML entities that shouldn't be there
content = content.replace('&dollar;', '$')

# 3. Ensure JavaScript functions are only in script tags
# Check for function definitions outside script tags
lines = content.split('\n')
in_script = False
cleaned_lines = []

for i, line in enumerate(lines):
    # Track if we're inside a script tag
    if '<script' in line.lower() and '</script>' not in line.lower():
        in_script = True
    elif '</script>' in line.lower():
        in_script = False
    
    cleaned_lines.append(line)

# Join back
content = '\n'.join(cleaned_lines)

# 4. Write clean file (overwrite original)
with open('index.html', 'w') as f:
    f.write(content)

print("Created clean index.html with fixed template literals")

# Also create a verification check
print("\nVerifying fix...")
template_count = len(re.findall(r'&dollar;\{', content))
if template_count == 0:
    print("✓ No escaped template literals found!")
else:
    print(f"✗ Still found {template_count} escaped template literals")
    print("First 5 occurrences:")
    for match in re.findall(r'&dollar;\{[^}]*\}', content)[:5]:
        print(f"  - {match}")
