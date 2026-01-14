import re

with open('index.html', 'r') as f:
    content = f.read()

print("Checking script tags...")

# Find all script tags
script_tags = re.findall(r'<script[^>]*>.*?</script>', content, re.DOTALL)

print(f"Found {len(script_tags)} script tags")

# Check each one
for i, script in enumerate(script_tags[:10]):
    print(f"\nScript tag {i+1}:")
    print(f"  Length: {len(script)} chars")
    print(f"  First 100 chars: {script[:100]}...")
    
    # Check if it contains the problematic function
    if 'openMediaPlayer' in script:
        print(f"  Contains openMediaPlayer function")
    
    # Check if it's properly closed
    if script.count('<script') != script.count('</script>'):
        print(f"  ⚠️ Possibly malformed!")

# Now check for JavaScript outside script tags
print("\n" + "="*50)
print("Checking for JavaScript code outside script tags...")

# Simple check: look for "function " not in script tags
lines = content.split('\n')
in_script = False
js_outside = []

for i, line in enumerate(lines):
    if '<script' in line and '</script>' not in line:
        in_script = True
    if '</script>' in line:
        in_script = False
    
    if not in_script and 'function ' in line and not line.strip().startswith('//'):
        js_outside.append((i+1, line.strip()))

if js_outside:
    print(f"Found {len(js_outside)} function definitions outside script tags:")
    for line_num, line in js_outside[:10]:
        print(f"  Line {line_num}: {line[:80]}...")
else:
    print("No function definitions found outside script tags.")

# Check for template literals outside script tags
print("\n" + "="*50)
print("Checking for template literals outside script tags...")

in_script = False
templates_outside = []

for i, line in enumerate(lines):
    if '<script' in line and '</script>' not in line:
        in_script = True
    if '</script>' in line:
        in_script = False
    
    if not in_script and '`' in line and '${' in line:
        templates_outside.append((i+1, line.strip()))

if templates_outside:
    print(f"Found {len(templates_outside)} template literals outside script tags:")
    for line_num, line in templates_outside[:10]:
        print(f"  Line {line_num}: {line[:80]}...")
else:
    print("No template literals found outside script tags.")
