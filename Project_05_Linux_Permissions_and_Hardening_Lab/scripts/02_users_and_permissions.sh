#!/usr/bin/env bash
# ==============================================================================
# Module 02: Users, Groups, File Permissions, Sticky Bit & POSIX ACLs
# ==============================================================================
set -euo pipefail

TARGET_USER="student"
TARGET_GROUP="lab"
PRIMARY_USER="${SUDO_USER:-kali}"
NOTES_DIR="/home/${PRIMARY_USER}/notes"
SHARE_DIR="/srv/labshare"

echo "[*] 1. Provisioning user '${TARGET_USER}' and group '${TARGET_GROUP}'..."
if ! getent group "${TARGET_GROUP}" >/dev/null; then
    groupadd "${TARGET_GROUP}"
    echo "[+] Group '${TARGET_GROUP}' created."
else
    echo "[i] Group '${TARGET_GROUP}' already exists."
fi

if ! id "${TARGET_USER}" >/dev/null 2>&1; then
    useradd -m -s /bin/bash "${TARGET_USER}"
    echo "${TARGET_USER}:StudentLab@2026!" | chpasswd
    echo "[+] User '${TARGET_USER}' created with default lab password."
else
    echo "[i] User '${TARGET_USER}' already exists."
fi

usermod -aG "${TARGET_GROUP}" "${TARGET_USER}"
chage -M 90 -m 7 -W 14 "${TARGET_USER}"
echo "[+] Added '${TARGET_USER}' to '${TARGET_GROUP}' and enforced password aging policy."
id "${TARGET_USER}"

echo "[*] 2. Creating test files and applying 600, 640, and 755 permissions..."
mkdir -p "${NOTES_DIR}"
echo "TOP SECRET: Private API Key = KALI-9981-SEC" > "${NOTES_DIR}/private.txt"
echo "INTERNAL: Group configuration parameters" > "${NOTES_DIR}/group_config.txt"
cat << 'EOF' > "${NOTES_DIR}/run_check.sh"
#!/usr/bin/env bash
echo "[+] Permission check script executed by $(whoami) at $(date)"
EOF

chown "${PRIMARY_USER}:${PRIMARY_USER}" "${NOTES_DIR}/private.txt"
chmod 600 "${NOTES_DIR}/private.txt"

chown "${PRIMARY_USER}:${TARGET_GROUP}" "${NOTES_DIR}/group_config.txt"
chmod 640 "${NOTES_DIR}/group_config.txt"

chown "${PRIMARY_USER}:${PRIMARY_USER}" "${NOTES_DIR}/run_check.sh"
chmod 755 "${NOTES_DIR}/run_check.sh"

chown -R "${PRIMARY_USER}:${PRIMARY_USER}" "${NOTES_DIR}"
chown "${PRIMARY_USER}:${TARGET_GROUP}" "${NOTES_DIR}/group_config.txt"

echo "[*] 3. Configuring shared directory '${SHARE_DIR}' with Sticky Bit (1770) & ACL..."
mkdir -p "${SHARE_DIR}"
chown root:"${TARGET_GROUP}" "${SHARE_DIR}"
chmod 1770 "${SHARE_DIR}"

if command -v setfacl >/dev/null 2>&1; then
    setfacl -m u:"${PRIMARY_USER}":rwx "${SHARE_DIR}"
    echo "[+] Applied POSIX ACL granting '${PRIMARY_USER}' explicit rwx access to ${SHARE_DIR}."
fi

echo "[*] 4. Verification Summary:"
ls -la "${NOTES_DIR}"
ls -ld "${SHARE_DIR}"
getfacl -p "${SHARE_DIR}" 2>/dev/null || true

echo "[*] 5. Simulating access boundary test as '${TARGET_USER}':"
su - "${TARGET_USER}" -c "cat ${NOTES_DIR}/private.txt 2>&1 || true"
su - "${TARGET_USER}" -c "touch ${SHARE_DIR}/student_verified.txt && ls -l ${SHARE_DIR}/student_verified.txt"
