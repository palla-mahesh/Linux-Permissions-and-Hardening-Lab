# Project 05: Linux Permissions and Hardening Lab (Kali Linux)

## Overview
A complete, automated, and auditable Linux security hardening and access control lab environment built for Kali Linux. This project fulfills all requirements for InternCircle Cybersecurity Project 05 while integrating enterprise-grade security controls including POSIX ACLs, Sticky Bit collaboration directories, UFW rate-limiting, SSH public-key hardening, Fail2Ban IPS, Sysctl kernel network hardening, and Lynis security benchmarking.

## Repository Structure
```text
Project_05_Linux_Permissions_and_Hardening_Lab/
├── README.md                           # Project documentation & quickstart guide
├── scripts/
│   ├── 01_system_update.sh             # System package synchronization & upgrade
│   ├── 02_users_and_permissions.sh     # User/group creation, chmod/chown, Sticky Bit & ACLs
│   ├── 03_service_and_suid_audit.sh    # Active service enumeration, open ports & SUID/SGID scan
│   ├── 04_firewall_and_fail2ban.sh     # UFW default-deny firewall, rate limiting & Fail2Ban IPS
│   ├── 05_ssh_and_kernel_hardening.sh  # SSH daemon hardening & sysctl network stack protection
│   ├── 06_lynis_security_audit.sh      # Automated system security audit & hardening index
│   └── run_all_hardening.sh            # Master orchestrator script
├── configs/
│   ├── sshd_hardening.conf             # Drop-in hardened OpenSSH server configuration
│   ├── jail.local                      # Fail2Ban SSH brute-force protection jail
│   └── 99-security-hardening.conf      # Kernel network parameters (sysctl)
├── docs/
│   ├── Lab_Execution_Checklist.md      # Pre-flight snapshot & verification checklist
│   └── Lessons_Learned.md              # Key cybersecurity takeaways & risk analysis
└── evidence/
    └── sample_outputs/
        ├── permissions_audit.txt       # Expected ls -l, getfacl, and id verification output
        ├── ufw_firewall_status.txt     # Expected ufw status verbose output
        └── ssh_hardening_verify.txt    # Expected sshd -T verification output
```

## Prerequisites & Safety Rules
1. **Isolated VM Only:** Execute these scripts strictly inside an isolated Kali Linux VirtualBox VM. Never run hardening scripts on a host workstation without prior testing.
2. **VM Snapshot:** Take a VirtualBox snapshot (`Clean Baseline`) before running `04_firewall_and_fail2ban.sh` or `05_ssh_and_kernel_hardening.sh`.
3. **SSH Key Setup:** Before applying SSH hardening (`PasswordAuthentication no`), ensure your host SSH public key is copied to the VM via `ssh-copy-id`.

## Quickstart Execution in Kali Linux
```bash
# 1. Extract the project archive
unzip Project_05_Linux_Permissions_and_Hardening_Lab.zip
cd Project_05_Linux_Permissions_and_Hardening_Lab

# 2. Grant execute permissions to all scripts
chmod +x scripts/*.sh

# 3. Run individual modules step-by-step (Recommended for screenshot evidence)
sudo ./scripts/01_system_update.sh
sudo ./scripts/02_users_and_permissions.sh
sudo ./scripts/03_service_and_suid_audit.sh
sudo ./scripts/04_firewall_and_fail2ban.sh
sudo ./scripts/05_ssh_and_kernel_hardening.sh
sudo ./scripts/06_lynis_security_audit.sh
```
