#!/usr/bin/env bash
# Sets up a web server for deployment of web_static.


# Install Nginx if not already installed
if ! dpkg -l | grep -q nginx; then
    apt-get update
    apt-get -y install nginx
fi

# Create necessary directories and files
mkdir -p /data/web_static/releases/test/
mkdir -p /data/web_static/shared/
echo "Hello, this is a test HTML file." > /data/web_static/releases/test/index.html

# Create symbolic link, deleting it if it already exists
rm -rf /data/web_static/current
ln -s /data/web_static/releases/test/ /data/web_static/current

# Set ownership to ubuntu user and group recursively
chown -R ubuntu:ubuntu /data/

# Configure Nginx to serve content and restart Nginx
config_text="
server {
    listen 80;
    server_name _;
    location /hbnb_static {
        alias /data/web_static/current/;
        index index.html;
    }
    error_page 404 /404.html;
    location = /404.html {
        root /usr/share/nginx/html;
        internal;
    }
}
"

echo "$config_text" > /etc/nginx/sites-available/default
service nginx restart
