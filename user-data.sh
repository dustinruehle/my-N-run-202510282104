#!/bin/bash
set -e

# Update system
yum update -y

# Install Node.js
curl -sL https://rpm.nodesource.com/setup_18.x | bash -
yum install -y nodejs

# Install AWS CLI
yum install -y aws-cli

# Create app directory
mkdir -p /home/ec2-user/app
cd /home/ec2-user/app

# Download config from S3
aws s3 cp s3://${bucket_name}/config.json ./config.json --region ${aws_region}
aws s3 cp s3://${bucket_name}/message.txt ./message.txt --region ${aws_region}

# Create simple Node.js app
cat > server.js << 'EOF'
const http = require('http');
const fs = require('fs');

const config = JSON.parse(fs.readFileSync('config.json', 'utf8'));
const message = fs.readFileSync('message.txt', 'utf8');

const server = http.createServer((req, res) => {
  res.writeHead(200, {'Content-Type': 'text/html'});
  res.end(`
    <html>
      <head><title>${'${config.app_name}'}</title></head>
      <body>
        <h1>${'${message}'}</h1>
        <p>App: ${'${config.app_name}'}</p>
        <p>Version: ${'${config.version}'}</p>
        <p>Deployed via Temporal + Terraform Cloud</p>
      </body>
    </html>
  `);
});

server.listen(80, () => {
  console.log('Server running on port 80');
});
EOF

# Set ownership
chown -R ec2-user:ec2-user /home/ec2-user/app

# Run the app
node server.js > /var/log/app.log 2>&1 &
