#!/usr/bin/env bash
# ==============================================================================
# Module 06: Automated Security Benchmarking with Lynis
# ==============================================================================
set -euo pipefail

REPORT_DIR="./evidence"
mkdir -p "${REPORT_DIR}"

echo "[*] Installing Lynis security auditing tool..."
apt-get install -y lynis

echo "[*] Running Lynis quick system audit..."
lynis audit system --quick | tee "${REPORT_DIR}/lynis_audit_report.txt"

echo "[+] Lynis audit complete. Report saved to ${REPORT_DIR}/lynis_audit_report.txt"
