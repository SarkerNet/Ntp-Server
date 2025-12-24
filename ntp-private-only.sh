#!/bin/bash
# ntp-private-only.sh
# Install and configure NTP with access restricted to private IP ranges + 103.135.132.0/23

set -e

echo "Updating package list..."
sudo apt update -y

echo "Installing NTP service..."
sudo apt install -y ntp

echo "Setting timezone to Asia/Dhaka (UTC+6)..."
sudo timedatectl set-timezone Asia/Dhaka

echo "Backing up default NTP config..."
sudo cp /etc/ntp.conf /etc/ntp.conf.bak

echo "Writing new NTP configuration..."
cat <<EOF | sudo tee /etc/ntp.conf
# NTP configuration for Bangladesh (UTC+6)
driftfile /var/lib/ntp/ntp.drift

# Asia pool servers
server 0.asia.pool.ntp.org iburst
server 1.asia.pool.ntp.org iburst
server 2.asia.pool.ntp.org iburst
server 3.asia.pool.ntp.org iburst

# Default: deny all
restrict default ignore

# Allow localhost
restrict 127.0.0.1
restrict ::1

# Allow private ranges
restrict 10.0.0.0 mask 255.0.0.0 nomodify notrap
restrict 172.16.0.0 mask 255.240.0.0 nomodify notrap
restrict 192.168.0.0 mask 255.255.0.0 nomodify notrap

# Allow custom subnet 103.135.132.0/23
restrict 103.135.132.0 mask 255.255.254.0 nomodify notrap
EOF

echo "Restarting NTP service..."
sudo systemctl restart ntp
sudo systemctl enable ntp

echo "Verifying NTP status..."
timedatectl status
ntpq -p

echo "✅ NTP setup complete: only private IP ranges + 103.135.132.0/23 can access."
