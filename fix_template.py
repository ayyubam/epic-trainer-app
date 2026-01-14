import re
import sys

with open('index.html', 'r') as f:
    content = f.read()

# Fix template literals with upload variables
patterns = [
    (r'" \+\s*upload\.(\w+)\s*\+ "', r'${upload.\1}'),
    (r'" \+\s*\(upload\.(\w+)\s*\|\|\s*""\)\s*\+ "', r'${upload.\1 || ""}'),
    (r'" \+\s*\(upload\.(\w+)\s*\|\|\s*"([^"]*)"\)\s*\+ "', r'${upload.\1 || "\2"}'),
]

for pattern, replacement in patterns:
    content = re.sub(pattern, replacement, content)

with open('index.html.fixed', 'w') as f:
    f.write(content)

print("Fixed version saved as index.html.fixed")
