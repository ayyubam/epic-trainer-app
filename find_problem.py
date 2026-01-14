import re

with open('index.html', 'r') as f:
    content = f.read()

# Look for the exact pattern you're seeing
pattern = r'\\\$\{upload\.title\}.*?\\\$\{renderMediaContent\(upload, mediaURL\)\}'
matches = re.findall(pattern, content, re.DOTALL)

if matches:
    print(f"Found {len(matches)} problematic section(s)")
    for i, match in enumerate(matches, 1):
        print(f"\n=== Match {i} ===")
        print(match[:500])
        
    # Find the context around this
    context = re.search(r'.{0,500}' + re.escape(matches[0][:50]) + r'.{0,500}', content, re.DOTALL)
    if context:
        print(f"\n=== Context ===")
        print(context.group())
else:
    print("Pattern not found. Looking for similar patterns...")
    
    # Look for renderMediaContent calls
    render_calls = re.findall(r'.{0,200}renderMediaContent.*upload.*mediaURL.{0,200}', content, re.DOTALL)
    for call in render_calls[:5]:
        print(f"Found: {call}")
