#!/bin/bash

cd /home/ubuntu
git clone https://github.com/rohitbhanushali/uber-clone-source-code.git
cd uber-clone-source-code

# Create .env file with required environment variables
cat > .env.local << 'EOF'
NEXT_PUBLIC_FIREBASE_API_KEY=AIzaSyD8S6cXohln1R9Ru8BeB_okavtC3HtlTeU
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=uber-clone-4491b.firebaseapp.com
NEXT_PUBLIC_FIREBASE_PROJECT_ID=uber-clone-4491b
NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET=uber-clone-4491b.firebasestorage.app
NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=870236846499
NEXT_PUBLIC_FIREBASE_APP_ID=1:870236846499:web:15c2e61152915eb2d58216
NEXT_PUBLIC_FIREBASE_MEASUREMENT_ID=G-5QE8XMNGH0
NEXT_PUBLIC_MAPBOX_TOKEN=pk.eyJ1Ijoicm9oaXRiaGFudXNoYWxpMTEiLCJhIjoiY21heWVtMmdnMDBlODJrczdjbW5vZGg0NCJ9.TroIJ0zK2eT9N6RHSXOevQ
EOF

# Update system packages
sudo apt update

# Install required packages
sudo apt install nodejs npm -y

# Install project dependencies
sudo npm install
sudo npm audit fix --force
sudo npm install firebase mapbox-gl

# Create a health check file
echo "OK" > /home/ubuntu/health.html

# Start the application on all interfaces
HOST=0.0.0.0 PORT=3000 npm run dev &
