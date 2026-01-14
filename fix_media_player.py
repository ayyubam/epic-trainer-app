import re

with open('index.html', 'r') as f:
    content = f.read()

print("Fixing the openMediaPlayer function...")

# Find the problematic section with template literals
problematic_section = r'<h3>&dollar;{upload\.title}</h3>\s*<p>This is a &dollar;{upload\.type} document\. Click Download to save it to your device\.</p>'
replacement = r'<h3>${upload.title}</h3>\n                    <p>This is a ${upload.type} document. Click Download to save it to your device.</p>'

content = re.sub(problematic_section, replacement, content)

# Fix all remaining &dollar; patterns
content = content.replace('&dollar;{', '${')
content = content.replace('&dollar;', '$')

with open('index.html.media_fixed', 'w') as f:
    f.write(content)

print("Created index.html.media_fixed")
