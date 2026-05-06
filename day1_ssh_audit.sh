#!/bin/bash
echo "=== Day 1: SSH Config Audit ==="
grep -E "^Port|^PermitRootLogin|^PasswordAuthentication" /etc/ssh/sshd_config
