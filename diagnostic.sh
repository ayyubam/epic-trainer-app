#!/bin/bash
echo "=== DIAGNOSTIC ==="
echo "File size:" $(wc -l < index.html) "lines"
echo ""

# Look for template literals
echo "=== Template literals found ==="
grep -n '\`' index.html | wc -l | xargs echo "Backticks count:"
grep -n '\$\{' index.html | wc -l | xargs echo "\${ patterns:"
echo ""

# Look for the specific problematic text
echo "=== Searching for problematic text ==="
if grep -q '\\\\\\${upload\\\.title}' index.html; then
    echo "FOUND: \\\\\${upload\.title}"
    grep -n -B2 -A2 '\\\\\\${upload\\\.title}' index.html
else
    echo "NOT FOUND: \\\\\${upload\.title}"
fi

echo ""
echo "=== First 50 lines with upload. ==="
grep -n 'upload\.' index.html | head -50
