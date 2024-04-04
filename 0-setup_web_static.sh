#!/usr/bin/env bash
# This script sets up web servers for deployment of web_static

# Install Nginx if not already installed
if ! command -v nginx &>/dev/null; then
    apt-get update
    apt-get -y install nginx
fi

# Create necessary directories if they don't exist
mkdir -p /data/web_static/{releases/test,shared}

# Create fake HTML file for testing
echo "<html>
<head>
</head>
<body>
Holberton School
</body>
</html>" > /data/web_static/releases/test/index.html

# Create symbolic link
if [ -L /data/web_static/current ]; then
    rm /data/web_static/current
fi
ln -sf /data/web_static/releases/test/ /data/web_static/current

# Give ownership of /data/ to ubuntu user and group
chown -R ubuntu:ubuntu /data/

# Update Nginx configuration
config_file="/etc/nginx/sites-available/default"
new_config="location /hbnb_static {
    alias /data/web_static/current/;
    index index.html index.htm;
}"
# If configuration doesn't exist, add it, else replace existing
if ! grep -q "$new_config" "$config_file"; then
    sed -i "/^\tlocation \/ {/a $new_config" "$config_file"
fi

# Restart Nginx
service nginx restart

exit 0
