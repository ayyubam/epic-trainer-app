import re

with open('index.html', 'r') as f:
    content = f.read()

# Remove ALL backslash escapes from template literals
content = content.replace(r'\${', '${')

# Now find any remaining ${...} that are outside script tags and wrap them
parts = re.split(r'(<script[^>]*>.*?</script>)', content, flags=re.DOTALL)

result_parts = []
for i, part in enumerate(parts):
    if i % 2 == 0:  # Not a script tag
        # Escape any ${...} in HTML body by converting to HTML entities
        part = re.sub(r'\$\{', '&dollar;{', part)
    result_parts.append(part)

fixed_content = ''.join(result_parts)

with open('index.html.nuclear_fix', 'w') as f:
    f.write(fixed_content)

print("Created index.html.nuclear_fix")
print("This ensures template literals only work inside <script> tags")
