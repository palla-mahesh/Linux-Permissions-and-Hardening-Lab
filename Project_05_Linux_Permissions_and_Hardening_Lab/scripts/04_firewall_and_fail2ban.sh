#!/usr/bin/env bash
# ==============================================================================
# Module 04: UFW Firewall Configuration & Fail2Ban Intrusion Prevention
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "${SCRIPT_DIR}")"

echo "[*] Installing UFW and Fail2Ban..."
apt-get install -y ufw fail2ban

echo "[*] Configuring UFW Default Policies (Deny Incoming, Allow Outgoing)..."
ufw default deny incoming
ufw default allow outgoing

echo "[*] Allowing and Rate-Limiting OpenSSH (22/tcp)..."
ufw limit OpenSSH

echo "[*] Enabling UFW Firewall..."
ufw --force enable
ufw status verbose

echo "[*] Deploying hardened Fail2Ban jail.local configuration..."
cp "${PROJECT_ROOT}/configs/jail.local" /etc/fail2ban/jail.local
systemctl enable fail2ban
systemctl restart fail2ban

sleep 2
fail2ban-client status
fail2ban-client status sshd || true
echo "[+] Firewall and Fail2Ban IPS active."
