Project 05: Linux Permissions and Hardening Lab (Kali Linux)

Overview

Project 05: Linux Permissions and Hardening Lab is a hands-on defensive security project designed to enforce the Principle of Least Privilege (PoLP), minimize network attack surfaces, harden remote authentication protocols, and establish automated security auditing inside an isolated Kali Linux virtual machine.

While fulfilling every baseline requirement of the InternCircle Cybersecurity Internship guide, this project expands the implementation with enterprise-grade hardening controls including POSIX Access Control Lists (ACLs), Sticky Bit (1770) shared directories, SUID/SGID binary auditing, UFW connection rate-limiting, Fail2Ban intrusion prevention, kernel network stack hardening (sysctl), and Lynis compliance benchmarking.

Rules of Engagement & Ethical Disclaimer:

All scripts, permission modifications, firewall policies, SSH configurations, and security scans in this repository must be executed strictly inside a local, isolated VirtualBox VM owned by you. Never test or modify external or unauthorized systems.

Core & Enhanced Features

Security Domain

Baseline Requirement

Enhanced Hardening Controls Included

1. Virtualization & Recovery

Provision a Linux VM in VirtualBox and take a baseline snapshot.

Dual-adapter isolation (NAT + Host-Only) and pre/post-hardening snapshot checkpoints.

2. Patch Management

Synchronize repositories (apt update) and upgrade installed packages.

Full distribution upgrade (full-upgrade), orphaned dependency cleanup (autoremove), and OpenSSL/OpenSSH verification.

3. Identity & Access (IAM)

Create user student, group lab, and assign group membership.

Strict password aging policies (chage), non-privileged account isolation, and least-privilege group delegation.

4. File Permissions & ACLs

Practise chmod 600, 640, 755, 770, and chown across users.

Sticky Bit (1770) on /srv/labshare to prevent cross-user file deletion, granular POSIX ACLs (setfacl/getfacl), and SUID/SGID binary auditing.

5. Service Minimization

Enumerate active systemd units and identify unnecessary services.

Socket/port inspection via ss -tulnp and disabling unused attack surfaces (avahi-daemon, bluetooth).

6. Host Firewall (UFW)

Enable UFW, deny incoming by default, allow outgoing, and permit SSH.

SSH rate-limiting (ufw limit OpenSSH) against brute-force attacks and verbose packet logging.

7. SSH Hardening

Disable root login and password authentication using SSH keys.

Ed25519 key-pair enforcement, lockout-prevention verification checks, AllowUsers whitelisting, and idle session timeouts.

8. Intrusion Defense & Audit

Document commands, terminal outputs, screenshots, and lessons learned.

Fail2Ban automated SSH IP banning, sysctl kernel network protections, and Lynis hardening index benchmarking.

Repository Structure

Project_05_Linux_Permissions_and_Hardening_Lab/
├── README.md                           # Project overview, architecture, and execution guide
├── scripts/
│   ├── 01_system_update.sh             # Repository sync, full package upgrade, and cleanup
│   ├── 02_users_and_permissions.sh     # User/group setup, 600/640/755, Sticky Bit (1770) & ACLs
│   ├── 03_service_and_suid_audit.sh    # Running service enumeration, port scan & SUID audit
│   ├── 04_firewall_and_fail2ban.sh     # UFW default-deny setup, SSH rate-limiting & Fail2Ban
│   ├── 05_ssh_and_kernel_hardening.sh  # Safe OpenSSH hardening (with lockout guard) & sysctl
│   ├── 06_lynis_security_audit.sh      # Automated Lynis system vulnerability benchmark
│   └── run_all_hardening.sh            # Master orchestrator script to run all modules sequentially
├── configs/
│   ├── sshd_hardening.conf             # Hardened OpenSSH drop-in configuration
│   ├── jail.local                      # Fail2Ban SSH brute-force protection jail
│   └── 99-security-hardening.conf      # Kernel network stack hardening parameters (sysctl)
├── docs/
│   ├── Lab_Execution_Checklist.md      # Pre-flight snapshot & submission verification checklist
│   └── Lessons_Learned.md              # Key cybersecurity takeaways & risk analysis
└── evidence/
    └── sample_outputs/
        ├── permissions_audit.txt       # Verified id, ls -la, and cross-user permission outputs
        ├── ufw_firewall_status.txt     # Verified ufw status verbose output
        └── ssh_hardening_verify.txt    # Verified sshd -T active directive output


Prerequisites & Lab Environment

Host Machine: Windows, macOS, or Linux with virtualization (VT-x / AMD-V) enabled

Hypervisor: Oracle VirtualBox (free)

Guest OS: Kali Linux Rolling (64-bit VirtualBox Image or Installer ISO)

VM Resources: Minimum 2 vCPUs, 2 GB–4 GB RAM, 25 GB Virtual Disk

Step-by-Step Execution Guide (Kali Linux)

Step 0: Take a VirtualBox Snapshot (Critical)

Before executing any hardening scripts or modifying network/SSH settings:

Boot your Kali Linux VM and log in as your standard user (kali).

In VirtualBox, select Machine → Take Snapshot and save it as Snapshot-01-Clean-Baseline.

Keep a second terminal window open whenever modifying SSH or firewall rules to prevent accidental lockout.

Step 1: Extract the Project & Set Execution Permissions

Open a terminal inside your Kali Linux VM and prepare the scripts:

unzip Project_05_Linux_Permissions_and_Hardening_Lab.zip
cd Project_05_Linux_Permissions_and_Hardening_Lab
chmod +x scripts/*.sh


Step 2: Execute Hardening Modules Step-by-Step

Run each module individually so you can inspect the terminal outputs and capture required screenshots for your lab report:

# 1. Update system repositories and upgrade security packages
sudo ./scripts/01_system_update.sh

# 2. Provision 'student' user, 'lab' group, permissions (600/640/755/1770), and POSIX ACLs
sudo ./scripts/02_users_and_permissions.sh

# 3. Audit active systemd services, open sockets, and SUID binaries
sudo ./scripts/03_service_and_suid_audit.sh

# 4. Configure UFW firewall (default deny incoming, rate-limit SSH) and Fail2Ban IPS
sudo ./scripts/04_firewall_and_fail2ban.sh

# 5. Apply OpenSSH hardening and kernel network stack protections (sysctl)
sudo ./scripts/05_ssh_and_kernel_hardening.sh

# 6. Run automated Lynis security compliance audit
sudo ./scripts/06_lynis_security_audit.sh


(Optional) To execute the entire hardening pipeline sequentially in one command:

sudo ./scripts/run_all_hardening.sh


Built-In SSH Lockout Protection:

Script 05_ssh_and_kernel_hardening.sh automatically inspects ~/.ssh/authorized_keys before disabling PasswordAuthentication. If no public SSH key is detected, it safely keeps password authentication enabled and prints instructions for copying your Ed25519 public key (ssh-copy-id) first.

Verification & Expected Results

After completing all phases, verify your defensive posture using these commands:

Verify Users & Permissions:

id student
ls -la ~/notes /srv/labshare
getfacl /srv/labshare/student_report.txt


Expected: student belongs to lab; private.txt is -rw------- (600); /srv/labshare is drwxrwx--T (1770).

Verify Firewall & Intrusion Prevention:

sudo ufw status verbose
sudo fail2ban-client status sshd


Expected: UFW is active with deny (incoming), allow (outgoing), and 22/tcp (OpenSSH) LIMIT IN; Fail2Ban sshd jail is active.

Verify Hardened SSH Directives:

sudo sshd -T | grep -E "permitrootlogin|passwordauthentication|pubkeyauthentication|maxauthtries"


Expected: permitrootlogin no, passwordauthentication no (once SSH keys are installed), pubkeyauthentication yes, maxauthtries 3.

Submission Checklist

[x] All practical work performed strictly inside a local, isolated Kali Linux VM.

[x] VirtualBox snapshot created prior to modifying firewall or SSH configurations.

[x] User (student), group (lab), and permissions (600, 640, 755, 1770) verified across accounts (zero 777 permissions used).

[x] Unnecessary background services audited and disabled.

[x] UFW firewall enabled with default-deny incoming policy and rate-limited SSH.

[x] SSH daemon hardened and tested safely via key-based authentication.

[x] Lab report exported as PDF alongside terminal screenshots and lessons learned.
