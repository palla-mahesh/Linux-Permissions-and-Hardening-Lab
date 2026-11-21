#!/usr/bin/env bash
# ==============================================================================
# Master Orchestrator: Project 05 - Linux Permissions and Hardening Lab
# ==============================================================================
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
   echo "[!] Error: Please run this script as root using sudo."
   exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=================================================================="
echo "  INTERNCIRCLE PROJECT 05: LINUX PERMISSIONS & HARDENING LAB"
echo "=================================================================="
echo ""

bash "${SCRIPT_DIR}/01_system_update.sh"
echo "------------------------------------------------------------------"
bash "${SCRIPT_DIR}/02_users_and_permissions.sh"
echo "------------------------------------------------------------------"
bash "${SCRIPT_DIR}/03_service_and_suid_audit.sh"
echo "------------------------------------------------------------------"
bash "${SCRIPT_DIR}/04_firewall_and_fail2ban.sh"
echo "------------------------------------------------------------------"
bash "${SCRIPT_DIR}/05_ssh_and_kernel_hardening.sh"
echo "------------------------------------------------------------------"
bash "${SCRIPT_DIR}/06_lynis_security_audit.sh"

echo "=================================================================="
echo "[+] ALL LAB MODULES COMPLETED SUCCESSFULLY!"
echo "=================================================================="
