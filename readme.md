Here’s a **README-style guide** for the NTP setup script we built together. This explains what the script does, how to use it, and how the access rules work.

---

# 📘 README – NTP Setup Script (Ubuntu, Asia/Dhaka UTC+6)

## Overview
This script installs and configures the **NTP service** on Ubuntu.  
It sets the system timezone to **Asia/Dhaka (UTC+6)** and restricts NTP access so that **only private IP ranges** (192.168.0.0/16, 10.0.0.0/8, and 103.135.132.0/23) can query the server. All other networks are denied.

---

## Features
- ✅ Installs NTP daemon (`ntp` package).  
- ✅ Sets timezone to **Bangladesh Standard Time (UTC+6)**.  
- ✅ Configures Asia pool NTP servers for synchronization.  
- ✅ Restricts access to **private subnets only**:
  - `192.168.0.0/16`  
  - `10.0.0.0/8`  
  - `103.135.132.0/23`  
- ❌ Blocks all other external IPs by default.

---

## Usage

### 1. Save the Script
Save the script as `ntp-private-only.sh`.

### 2. Make Executable
```bash
chmod +x ntp-private-only.sh
```

### 3. Run the Script
```bash
./ntp-private-only.sh
```

---

## Verification

After running, check:
```bash
timedatectl status   # Verify timezone is Asia/Dhaka (UTC+6)
ntpq -p              # Show NTP peers and sync status
```

---

## Access Control Notes
- `restrict default ignore` → denies all clients by default.  
- `restrict 127.0.0.1` and `restrict ::1` → allow local queries.  
- `restrict <subnet> mask <netmask> nomodify notrap` → allows time queries from specified subnets.  
- Only **LAN/private ranges** and your custom subnet can access NTP.  

---

## Example Config Snippet
```bash
restrict default ignore
restrict 127.0.0.1
restrict ::1
restrict 192.168.0.0 mask 255.255.0.0 nomodify notrap
restrict 10.0.0.0 mask 255.0.0.0 nomodify notrap
restrict 103.135.132.0 mask 255.255.254.0 nomodify notrap
```

---

This README ensures anyone using your script knows exactly what it does and how to apply it.  

👉 I can also prepare a **README for Chrony-based setup** (modern replacement for NTP) if you’d like to support both daemons in your environment.
