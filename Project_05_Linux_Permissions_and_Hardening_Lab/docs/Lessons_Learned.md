# Lessons Learned & Security Takeaways

1. **Principle of Least Privilege (PoLP):** Applying `600` to sensitive files and `640` to group configuration files prevents unauthorized lateral movement if a non-privileged service account is compromised.
2. **Why `chmod 777` is Dangerous:** Granting read, write, and execute permissions to `others` allows any local user or compromised daemon on the system to overwrite executable scripts or inject malicious payloads, leading to immediate privilege escalation.
3. **Shared Collaboration Security with the Sticky Bit (`1770`):** In multi-user directories like `/srv/labshare`, standard group write permissions (`770`) allow any group member to delete another user's files. Adding the sticky bit (`1770`) restricts file deletion strictly to the file owner or `root`.
4. **Preventing Administrative Lockouts:** Always validate SSH configurations with `sshd -t`, maintain an active secondary session, and take a hypervisor snapshot before enforcing `PasswordAuthentication no` or enabling a `default deny` firewall.
5. **Defense-in-Depth:** Combining network perimeter filtering (UFW rate-limiting), authentication hardening (SSH keys + disabling root login), active intrusion prevention (Fail2Ban), and kernel-level network hardening (`sysctl`) provides layered resilience against automated attacks.
