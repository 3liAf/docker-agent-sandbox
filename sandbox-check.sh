#!/usr/bin/env bash
set -euo pipefail

# Health check script for docker-agent-sandbox
# Ensures container runtime maintains unprivileged user guarantees

echo "=== docker-agent-sandbox environment audit ==="

CURRENT_UID=$(id -u)
CURRENT_USER=$(id -un)

if [ "${CURRENT_UID}" -eq 0 ]; then
    echo "ERROR: Sandbox is running as root (UID 0). Refusing execution." >&2
    exit 1
fi

echo "Status: Running as unprivileged user: ${CURRENT_USER} (UID: ${CURRENT_UID})"
echo "Python: $(python3 --version 2>&1)"
echo "Node.js: $(node --version 2>&1)"
echo "Sandbox directory writable check..."

TMP_TEST_FILE="/sandbox/.write_test_$$"
if touch "${TMP_TEST_FILE}" 2>/dev/null; then
    rm -f "${TMP_TEST_FILE}"
    echo "Filesystem: /sandbox is writable by sandbox user."
else
    echo "WARNING: /sandbox is read-only. Mount temporary workspace or run with --tmpfs."
fi

echo "Sandbox integrity check passed."
exit 0
