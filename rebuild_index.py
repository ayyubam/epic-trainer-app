import re

print("Rebuilding index.html from scratch...")

try:
    with open('index.html.pre_nuclear_backup', 'r') as f:
        content = f.read()
except:
    with open('index.html', 'r') as f:
        content = f.read()

# Extract only the essential parts, rebuilding JavaScript properly
print("Extracting core structure...")

# Find the main parts
head_match = re.search(r'(<head>.*?</head>)', content, re.DOTALL | re.IGNORECASE)
body_match = re.search(r'(<body>.*?</body>)', content, re.DOTALL | re.IGNORECASE)

if not head_match or not body_match:
    print("Could not parse HTML structure. Creating basic template...")
    basic_html = '''<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Epic EMR Trainer Assistant</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h1>Epic EMR Trainer Assistant</h1>
    <p>Application is being rebuilt...</p>
    <script>
        // Clean JavaScript will go here
        console.log('Application loading...');
    </script>
</body>
</html>'''
    
    with open('index.html', 'w') as f:
        f.write(basic_html)
else:
    # Fix the body content
    body_content = body_match.group(1)
    
    # Remove ALL escaped template literals
    body_content = re.sub(r'&(amp;)?dollar;\{', '${', body_content)
    
    # Reconstruct the HTML
    clean_html = f'''<!DOCTYPE html>
<html lang="en">
{head_match.group(1)}
{body_content}
</html>'''
    
    with open('index.html', 'w') as f:
        f.write(clean_html)
    
    print("Rebuilt index.html successfully")

# Verify
with open('index.html', 'r') as f:
    verify_content = f.read()
    
escaped_count = len(re.findall(r'&(amp;)?dollar;\{', verify_content))
print(f"Found {escaped_count} escaped template literals in final file")
