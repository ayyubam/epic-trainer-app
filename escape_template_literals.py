import re

with open('index.html', 'r') as f:
    content = f.read()

# Split by script tags
parts = re.split(r'(<script[^>]*>.*?</script>)', content, flags=re.DOTALL)

fixed_parts = []
for i, part in enumerate(parts):
    # Only escape template literals outside script tags
    if not part.startswith('<script'):
        # Escape ${...} patterns
        part = re.sub(r'\$\{', '\\${', part)
    fixed_parts.append(part)

fixed_content = ''.join(fixed_parts)

# Write to new file
with open('index.html.escaped', 'w') as f:
    f.write(fixed_content)

print("Created index.html.escaped with escaped template literals")
print("Lines changed:", len(re.findall(r'\\\$\{', fixed_content)))
