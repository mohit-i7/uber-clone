#!/bin/bash

# Update system packages
apt-get update
apt-get upgrade -y

# Install Node.js and npm
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

# Install PM2 globally
npm install -y pm2 -g

# Create app directory
mkdir -p /home/ubuntu/app
cd /home/ubuntu/app

# Clone the repository (replace with your actual repository URL)
git clone https://github.com/rohitbhanushali/uber-clone-source-code.git .

# Install dependencies
npm install

# Start the application with PM2
pm2 start npm --name "uber-clone" -- run dev

# Make PM2 start on system boot
pm2 startup
pm2 save

# Create a simple health check page
cat > /home/ubuntu/app/public/health.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Health Check</title>
</head>
<body>
    <h1>Instance Health Check</h1>
    <p>Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>
    <p>Status: Healthy</p>
</body>
</html>
EOF

# Set proper permissions
chown -R ubuntu:ubuntu /home/ubuntu/app 