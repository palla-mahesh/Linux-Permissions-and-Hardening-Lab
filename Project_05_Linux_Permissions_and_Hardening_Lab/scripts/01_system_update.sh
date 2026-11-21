#!/usr/bin/env bash
# ==============================================================================
# Module 01: System Update & Baseline Package Synchronization
# ==============================================================================
set -euo pipefail

echo "[*] Starting Kali Linux package index update and full upgrade..."
apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get full-upgrade -y
apt-get autoremove -y
apt-get autoclean -y

echo "[+] System update completed successfully."
uname -a
lsb_release -a 2>/dev/null || cat /etc/os-release | head -n 4
