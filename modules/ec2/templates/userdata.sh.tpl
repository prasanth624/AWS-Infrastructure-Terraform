#!/bin/bash
set -euxo pipefail

# ==============================================================
# Userdata Script — Nginx Deployment
# Environment: ${environment}
# Project:     ${project_name}
# ==============================================================

exec > >(tee /var/log/userdata.log) 2>&1
echo ">>> Userdata script started at $(date)"

# ----------------------------------
# 1. System Update
# ----------------------------------
echo ">>> Updating system packages..."
yum update -y 2>/dev/null || apt-get update -y 2>/dev/null

# ----------------------------------
# 2. Install Nginx
# ----------------------------------
echo ">>> Installing Nginx..."
if command -v amazon-linux-extras &> /dev/null; then
    # Amazon Linux 2
    amazon-linux-extras install nginx1 -y
elif command -v dnf &> /dev/null; then
    # Amazon Linux 2023
    dnf install nginx -y
else
    # Ubuntu/Debian
    apt-get install nginx -y
fi

# ----------------------------------
# 3. Install CloudWatch Agent
# ----------------------------------
echo ">>> Installing CloudWatch Agent..."
if command -v yum &> /dev/null; then
    yum install -y amazon-cloudwatch-agent
else
    apt-get install -y amazon-cloudwatch-agent
fi

# ----------------------------------
# 4. Configure Nginx
# ----------------------------------
echo ">>> Configuring Nginx..."

cat > /etc/nginx/conf.d/app.conf <<'NGINX_CONF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;

    root /usr/share/nginx/html;
    index index.html;

    # Health check endpoint
    location /health {
        access_log off;
        return 200 'healthy\n';
        add_header Content-Type text/plain;
    }

    # Application status
    location /status {
        stub_status on;
        access_log off;
        allow 10.0.0.0/8;
        deny all;
    }

    location / {
        try_files $uri $uri/ =404;
    }

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;

    # Gzip
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml;
    gzip_min_length 256;
}
NGINX_CONF

# ----------------------------------
# 5. Create Custom Landing Page
# ----------------------------------
echo ">>> Creating landing page..."

INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id 2>/dev/null || echo "unknown")
PRIVATE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4 2>/dev/null || echo "unknown")
AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone 2>/dev/null || echo "unknown")

cat > /usr/share/nginx/html/index.html <<HTML_PAGE
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${project_name} — ${environment}</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #0f0c29, #302b63, #24243e);
            color: #fff;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .container {
            text-align: center;
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 20px;
            padding: 60px 40px;
            backdrop-filter: blur(10px);
            max-width: 600px;
            width: 90%;
        }
        .badge {
            display: inline-block;
            background: #00d4aa;
            color: #000;
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 20px;
        }
        h1 { font-size: 2.5rem; margin-bottom: 10px; }
        .env { color: #00d4aa; }
        p { color: #aaa; margin-bottom: 30px; font-size: 1.1rem; }
        .info {
            text-align: left;
            background: rgba(0,0,0,0.3);
            border-radius: 12px;
            padding: 20px;
        }
        .info div {
            display: flex;
            justify-content: space-between;
            padding: 8px 0;
            border-bottom: 1px solid rgba(255,255,255,0.05);
        }
        .info div:last-child { border: none; }
        .label { color: #888; }
        .value { color: #00d4aa; font-family: monospace; }
    </style>
</head>
<body>
    <div class="container">
        <span class="badge">● Running</span>
        <h1>${project_name}</h1>
        <p>Environment: <span class="env">${environment}</span></p>
        <div class="info">
            <div><span class="label">Instance ID</span><span class="value">$INSTANCE_ID</span></div>
            <div><span class="label">Private IP</span><span class="value">$PRIVATE_IP</span></div>
            <div><span class="label">AZ</span><span class="value">$AZ</span></div>
            <div><span class="label">Nginx</span><span class="value">Active</span></div>
            <div><span class="label">S3 Bucket</span><span class="value">${s3_bucket_name}</span></div>
            <div><span class="label">DB Host</span><span class="value">${db_host}</span></div>
        </div>
    </div>
</body>
</html>
HTML_PAGE

# ----------------------------------
# 6. Remove default server block
# ----------------------------------
rm -f /etc/nginx/sites-enabled/default 2>/dev/null || true
rm -f /etc/nginx/conf.d/default.conf 2>/dev/null || true

# ----------------------------------
# 7. Test & Start Nginx
# ----------------------------------
echo ">>> Starting Nginx..."
nginx -t
systemctl enable nginx
systemctl restart nginx

# ----------------------------------
# 8. Verify
# ----------------------------------
echo ">>> Verifying Nginx is running..."
sleep 2
curl -s http://localhost/health || echo "WARNING: Health check failed"

echo ">>> Userdata script completed at $(date)"
