import re

with open('index.html', 'r') as f:
    content = f.read()

print("Checking HTML structure...")

# Count script tags
script_open = len(re.findall(r'<script[^>]*>', content))
script_close = len(re.findall(r'</script>', content))

print(f"<script> tags: {script_open}")
print(f"</script> tags: {script_close}")

if script_open != script_close:
    print(f"⚠️ MISMATCH: Missing {abs(script_open - script_close)} script tags!")

# Look for template literals in the wrong places
lines = content.split('\n')
for i, line in enumerate(lines):
    if '`' in line and '${' in line:
        # Check if this is inside a script tag
        before = '\n'.join(lines[:i+1])
        script_open_pos = before.rfind('<script')
        script_close_pos = before.rfind('</script>')
        
        if script_open_pos < script_close_pos or script_open_pos == -1:
            print(f"\n⚠️ Line {i+1}: Template literal may be outside script tags")
            print(f"   Preview: {line.strip()[:100]}...")

print("\nChecking for the specific problematic code...")

# Search for the exact code structure from your screenshot
for i, line in enumerate(lines):
    if 'upload.title' in line and 'renderMediaContent' in line:
        print(f"\nLine {i+1}: Found upload.title and renderMediaContent together")
        print(f"   Content: {line.strip()[:150]}")
