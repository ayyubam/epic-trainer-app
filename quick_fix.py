import re

with open('index.html', 'r') as f:
    content = f.read()

# The pattern from your screenshot - this should NOT be in the HTML body
problem_text = r'\\\$\{upload\.title\}.*?\\\$\{renderMediaContent\(upload, mediaURL\)\}'

# Find and remove/escape this
if re.search(problem_text, content, re.DOTALL):
    print("Found the problematic text. Removing/fixing it...")
    
    # Replace with properly escaped version
    # Actually, this text shouldn't be in HTML at all - it's JavaScript code
    # Let's wrap it in a comment or remove it
    fixed_content = re.sub(problem_text, '<!-- MEDIA VIEWER CODE (removed from HTML body) -->', content, flags=re.DOTALL)
    
    with open('index.html.quick_fix', 'w') as f:
        f.write(fixed_content)
    
    print("Created index.html.quick_fix")
else:
    print("Problem text not found. Looking for similar issues...")
    
    # Look for any \${ patterns (escaped template literals)
    escaped = re.findall(r'\\\$\{[^}]*\}', content)
    if escaped:
        print(f"Found {len(escaped)} escaped template literals:")
        for e in escaped[:10]:
            print(f"  - {e[:50]}...")
        
        # Remove the escape characters
        fixed_content = content.replace(r'\${', '${')
        with open('index.html.remove_escapes', 'w') as f:
            f.write(fixed_content)
        print("\nCreated index.html.remove_escapes (removed \\ from \\${})")
