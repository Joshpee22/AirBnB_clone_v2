#!/usr/bin/env bash
# sets up my web servers for the deployment of web_static

echo -e "\e[1;32m START\e[0m"

# Update packages
sudo apt-get -y update
sudo apt-get -y install nginx
echo -e "\e[1;32m Packages updated\e[0m"
echo

# Configure firewall
sudo ufw allow 'Nginx HTTP'
echo -e "\e[1;32m Allow incoming NGINX HTTP connections\e[0m"
echo

# Create directories
sudo mkdir -p /data/web_static/releases/test /data/web_static/shared
echo -e "\e[1;32m Directories created\e[0m"
echo

# Add test string
echo "<h1>Welcome to www.smartcodez.tech</h1>" > /data/web_static/releases/test/index.html
echo -e "\e[1;32m Test string added\e[0m"
echo

# Prevent overwrite
if [ -d "/data/web_static/current" ]; then
    echo "Path /data/web_static/current exists. Removing..."
    sudo rm -rf /data/web_static/current
fi
echo -e "\e[1;32m Prevent overwrite\e[0m"
echo

# Create symbolic link
sudo ln -sf /data/web_static/releases/test/ /data/web_static/current
sudo chown -hR ubuntu:ubuntu /data
echo -e "\e[1;32m Symbolic link created\e[0m"
echo

# Update Nginx configuration
if ! grep -q "location /hbnb_static/ {" /etc/nginx/sites-available/default; then
    sudo sed -i '38i\\tlocation /hbnb_static/ {\n\t\talias /data/web_static/current/;\n\t}\n' /etc/nginx/sites-available/default
fi

# Create symbolic link in sites-enabled
sudo ln -sf '/etc/nginx/sites-available/default' '/etc/nginx/sites-enabled/default'
echo -e "\e[1;32m Symbolic link in sites-enabled created\e[0m"
echo

# Restart NGINX
sudo service nginx restart
echo -e "\e[1;32m Restart NGINX\e[0m"
