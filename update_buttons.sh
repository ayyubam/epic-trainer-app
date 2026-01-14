#!/bin/bash

# Update download buttons in resource cards
sed -i 's|<button class="btn btn-primary"><i class="fas fa-download"></i> Download</button>|<button class="btn btn-primary" onclick="downloadFile(\x27Epic-2023-Upgrade-Guide.pdf\x27)"><i class="fas fa-download"></i> Download</button>|g' public/index.html

sed -i 's|<button class="btn btn-primary"><i class="fas fa-play-circle"></i> Watch</button>|<button class="btn btn-primary" onclick="playVideo(\x27/resources/videos/tutorial.mp4\x27)"><i class="fas fa-play-circle"></i> Watch</button>|g' public/index.html

# Update the Resources section buttons specifically
sed -i 's|<button class="btn btn-primary"><i class="fas fa-download"></i> Download</button>|<!-- Updated buttons will be here -->|g' public/index.html

# More specific replacements for resource cards
# Find and replace the first resource card download button
sed -i '0,/<button class="btn btn-primary"><i class="fas fa-download"><\/i> Download<\/button>/{s/<button class="btn btn-primary"><i class="fas fa-download"><\/i> Download<\/button>/<button class="btn btn-primary" onclick="downloadFile(\x27Epic-Fundamentals-Training-Guide.pdf\x27)"><i class="fas fa-download"><\/i> Download<\/button>/}' public/index.html

# Find and replace the second resource card watch button
sed -i '0,/<button class="btn btn-primary"><i class="fas fa-play-circle"><\/i> Watch<\/button>/{s/<button class="btn btn-primary"><i class="fas fa-play-circle"><\/i> Watch<\/button>/<button class="btn btn-primary" onclick="playVideo(\x27/resources/videos/mychart-tutorial.mp4\x27)"><i class="fas fa-play-circle"><\/i> Watch<\/button>/}' public/index.html

# Add initFileUpload() call to the DOMContentLoaded event
sed -i '/console.log(\"Enhanced Epic Trainer initialized!\");/a\    \n    // Initialize file upload handling\n    initFileUpload();' public/index.html

echo "Buttons updated successfully!"
