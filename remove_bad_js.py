import re

with open('index.html', 'r') as f:
    content = f.read()

print("Searching for problematic JavaScript that's rendering as HTML...")

# This regex looks for JavaScript-like code that's not in script tags
# Pattern: starts with ${, contains upload., ends with }
pattern = r'(\$\{[^}]*upload\.[^}]*\})'

matches = re.findall(pattern, content)
print(f"Found {len(matches)} potential problematic template interpolations")

if matches:
    print("\nFirst few matches:")
    for i, match in enumerate(matches[:10]):
        print(f"{i+1}. {match[:100]}...")
    
    # Now fix by ensuring these are only in script tags
    # Actually, let's just escape them in HTML context
    lines = content.split('\n')
    fixed_lines = []
    
    in_script = False
    changes = 0
    
    for line in lines:
        # Track script tags
        if '<script' in line and '</script>' not in line:
            in_script = True
        if '</script>' in line:
            in_script = False
        
        # If NOT in script and has ${...}, escape it
        if not in_script and '${' in line:
            original = line
            line = line.replace('${', '&dollar;{')
            if line != original:
                changes += 1
                print(f"Fixed line: {line[:100]}...")
        
        fixed_lines.append(line)
    
    print(f"\nMade {changes} changes")
    
    with open('index.html.fixed_final', 'w') as f:
        f.write('\n'.join(fixed_lines))
    
    print("Created index.html.fixed_final")
else:
    print("No matches found. The issue might be different.")
