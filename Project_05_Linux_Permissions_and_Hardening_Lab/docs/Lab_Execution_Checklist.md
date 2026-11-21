# Pre-Submission Verification Checklist (Project 05)

- [x] **Isolated Environment:** All commands executed exclusively inside an isolated VirtualBox Kali Linux VM.
- [x] **VM Snapshot Taken:** Baseline snapshot created prior to firewall and SSH daemon changes.
- [x] **System Updated:** `apt update && apt full-upgrade` executed cleanly.
- [x] **Users & Groups:** User `student` created and added to supplementary group `lab`; password aging (`chage`) applied.
- [x] **Permissions Validated:** `600` (`private.txt`), `640` (`group_config.txt`), `755` (`run_check.sh`), and `1770` Sticky Bit (`/srv/labshare`) tested across users.
- [x] **Services Audited:** Active systemd services and open ports reviewed (`systemctl` & `ss -tulnp`).
- [x] **Firewall Active:** UFW configured with `default deny incoming`, `default allow outgoing`, and `limit OpenSSH`.
- [x] **SSH Hardened:** `PermitRootLogin no`, key-based authentication verified, `sshd -t` passed, and second terminal kept open during testing.
- [x] **Defense-in-Depth:** Fail2Ban `sshd` jail, `sysctl` kernel protections, and Lynis security audit verified.
