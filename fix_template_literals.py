import re

with open('index.html', 'r') as f:
    content = f.read()

print("Fixing incorrectly escaped template literals...")

# Pattern to find &dollar;{...} and replace with ${...}
pattern = r'&dollar;\{([^}]+)\}'

def replace_match(match):
    return f'${{{match.group(1)}}}'

fixed_content = re.sub(pattern, replace_match, content)

# Also fix other potential issues
fixed_content = fixed_content.replace('&dollar;{', '${')
fixed_content = fixed_content.replace('&amp;dollar;{', '${')

# Count how many were fixed
original_count = len(re.findall(r'&dollar;\{', content))
fixed_count = len(re.findall(r'&dollar;\{', fixed_content))

print(f"Fixed {original_count - fixed_count} template literals")

with open('index.html.fixed', 'w') as f:
    f.write(fixed_content)

print("Created index.html.fixed")
