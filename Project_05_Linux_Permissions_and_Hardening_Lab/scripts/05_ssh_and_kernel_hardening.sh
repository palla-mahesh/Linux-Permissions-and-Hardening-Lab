#!/usr/bin/env bash
# ==============================================================================
# Module 05: OpenSSH Server Hardening & Sysctl Kernel Network Hardening
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "${SCRIPT_DIR}")"
PRIMARY_USER="${SUDO_USER:-kali}"
AUTH_KEYS="/home/${PRIMARY_USER}/.ssh/authorized_keys"

echo "[*] 1. Applying Sysctl Kernel Network Hardening..."
cp "${PROJECT_ROOT}/configs/99-security-hardening.conf" /etc/sysctl.d/99-security-hardening.conf
sysctl --system >/dev/null
echo "[+] Kernel network parameters applied."

echo "[*] 2. Backing up /etc/ssh/sshd_config..."
cp /etc/ssh/sshd_config "/etc/ssh/sshd_config.bak.$(date +%Y%m%d_%H%M%S)"

echo "[*] 3. Deploying hardened SSH drop-in configuration..."
mkdir -p /etc/ssh/sshd_config.d
cp "${PROJECT_ROOT}/configs/sshd_hardening.conf" /etc/ssh/sshd_config.d/99-hardening.conf

# Safety check: warn if authorized_keys is missing before disabling PasswordAuthentication
if [[ ! -s "${AUTH_KEYS}" ]]; then
    echo "[!] WARNING: ${AUTH_KEYS} does not exist or is empty!"
    echo "[!] Keeping PasswordAuthentication enabled temporarily to prevent SSH lockout."
    echo "[!] Run 'ssh-copy-id ${PRIMARY_USER}@<VM_IP>' from your host, then set PasswordAuthentication no in /etc/ssh/sshd_config.d/99-hardening.conf"
    sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config.d/99-hardening.conf
fi

echo "[*] 4. Validating SSH daemon configuration syntax..."
sshd -t
systemctl enable ssh
systemctl restart ssh

echo "[+] Effective Hardened SSH Directives:"
sshd -T | grep -E "^(permitrootlogin|passwordauthentication|pubkeyauthentication|maxauthtries|x11forwarding|permituserenvironment|clientaliveinterval)"
