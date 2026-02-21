#!/bin/bash

# Create a temporary credentials file
cat > /tmp/credentials.yml << 'EOF'
# Admin password for the custom admin panel
admin_password: changeme123

# Used as the base secret for all MessageVerifiers in Rails
secret_key_base: b003f68d3c80d5758eb082919188ef9688bdefa5cb8a9bcaf0bb041809786e8cdc616ef00ae4b8ad860fd1f9578b82e5d6960949f0362b4f888f1e6f04f50ab8
EOF

# Encrypt and save
EDITOR="cp /tmp/credentials.yml" bin/rails credentials:edit

rm /tmp/credentials.yml

echo "Admin credentials configured!"
echo "Username: admin"
echo "Password: changeme123"
