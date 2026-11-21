#!/usr/bin/env bash
# ==============================================================================
# Module 03: Service Enumeration, Open Ports & SUID/SGID Binary Audit
# ==============================================================================
set -euo pipefail

REPORT_DIR="./evidence"
mkdir -p "${REPORT_DIR}"
AUDIT_LOG="${REPORT_DIR}/service_and_suid_audit_$(date +%Y%m%d_%H%M%S).log"

{
    echo "=========================================================="
    echo "KALI LINUX SERVICE & PRIVILEGE AUDIT - $(date)"
    echo "=========================================================="
    echo ""
    echo "[1] ACTIVE SYSTEMD SERVICES:"
    systemctl list-units --type=service --state=running --no-pager

    echo ""
    echo "[2] LISTENING NETWORK SOCKETS (TCP/UDP):"
    ss -tulnp

    echo ""
    echo "[3] SUID/SGID BINARIES AUDIT (Potential Privilege Escalation Vectors):"
    find / -perm /6000 -type f 2>/dev/null | sort

    echo ""
    echo "[4] WORLD-WRITABLE FILES IN /etc AND /srv (Should be empty):"
    find /etc /srv -type f -perm -0002 2>/dev/null || echo "None found."
} | tee "${AUDIT_LOG}"

echo "[+] Audit complete. Output saved to ${AUDIT_LOG}"
