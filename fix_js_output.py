import re

with open('index.html', 'r') as f:
    content = f.read()

print("Looking for JavaScript code that might be output as HTML...")

# Pattern to find template literals that might be in wrong context
# Look for backticks followed by ${...} patterns
pattern = r'`[^`]*\$\{[^`]*`'

matches = re.findall(pattern, content)
print(f"Found {len(matches)} template literals")

# Now look for the specific problematic pattern from your screenshot
problem_pattern = r'(\$\{upload\.title\}.*?\$\{renderMediaContent\(upload, mediaURL\)\})'

problem = re.search(problem_pattern, content, re.DOTALL)
if problem:
    print(f"\n=== FOUND THE PROBLEM ===")
    problem_text = problem.group(1)
    print(f"Problematic text length: {len(problem_text)} chars")
    print(f"First 200 chars: {problem_text[:200]}")
    
    # Get more context
    start = max(0, problem.start() - 200)
    end = min(len(content), problem.end() + 200)
    context = content[start:end]
    
    print(f"\n=== CONTEXT ===")
    print(context)
    
    # Check if this is inside a <script> tag
    before_problem = content[:problem.start()]
    script_open = before_problem.rfind('<script')
    script_close = before_problem.rfind('</script>')
    
    if script_open > script_close:
        print("\n✓ GOOD: Problem is inside a <script> tag")
    else:
        print("\n✗ PROBLEM: Code is OUTSIDE <script> tags!")
        print("This JavaScript code is being rendered as HTML text.")
        
        # Fix it by wrapping in <script> tags or moving it
        fixed_content = content[:problem.start()] + '<script>' + problem_text + '</script>' + content[problem.end():]
        
        with open('index.html.problem_fixed', 'w') as f:
            f.write(fixed_content)
        
        print("\nCreated index.html.problem_fixed with the code wrapped in <script> tags")
else:
    print("Could not find the exact problem pattern.")
    
    # Try to find similar issues
    print("\nLooking for similar issues...")
    
    # Find all ${...} patterns outside of script tags
    # This is more complex but let's try a simple approach
    parts = re.split(r'(<script[^>]*>.*?</script>)', content, flags=re.DOTALL)
    
    for i, part in enumerate(parts):
        if not part.startswith('<script'):
            # Check for ${...} in this part (outside script tags)
            template_matches = re.findall(r'\$\{[^}]*\}', part)
            if template_matches:
                print(f"\nFound ${len(template_matches)} template literals OUTSIDE script tags in part {i}:")
                for tm in template_matches[:5]:
                    print(f"  - {tm[:50]}...")
