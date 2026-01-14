import re

with open('index.html', 'r') as f:
    content = f.read()

print("Applying final simple fix...")

# Split by script tags
parts = re.split(r'(<script[^>]*>.*?</script>)', content, flags=re.DOTALL)

result = []
for i, part in enumerate(parts):
    # Even indices are outside script tags, odd are inside
    if i % 2 == 0:  # Outside script tags
        # Escape ${...} patterns
        part = re.sub(r'\$\{', '${', part)  # Remove any existing escapes
        part = re.sub(r'\$\{', '&dollar;{', part)  # HTML escape
    result.append(part)

fixed_content = ''.join(result)

with open('index.html.final', 'w') as f:
    f.write(fixed_content)

print("Created index.html.final")
print("This ensures template literals only work inside <script> tags")
