#!/bin/bash
set -euxo pipefail

# Install Nginx
dnf install -y nginx

# Create our demonstration webpage
cat > /usr/share/nginx/html/index.html <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>AWS Cloud Engineering Portfolio</title>
</head>
<body style="font-family:Arial,sans-serif;
             text-align:center;
             padding:60px;">
  <h1>My First Terraform EC2 Web Server!</h1>
  <p>Deployed automatically with Terraform.</p>
  <p>Amazon EC2 | Amazon Linux 2023 | Nginx</p>
  <p>Project 2 - AWS Cloud Engineering Portfolio</p>
</body>
</html>
EOF

# Start Nginx automatically
systemctl enable --now nginx
