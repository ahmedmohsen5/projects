#!/bin/bash

echo "===== EC2 HEALTH CHECK ====="
echo "Host: $(hostname)"
echo "Time: $(date)"
echo

echo "===== UPTIME ====="
uptime
echo

echo "===== DISK ====="
df -h /
echo

echo "===== MEMORY ====="
free -m
echo

echo "===== SSH SERVICE ====="
if systemctl is-active --quiet sshd; then
  echo "[OK] sshd service is running"
else
  echo "[FAIL] sshd service is not running"
fi
echo

echo "===== SSH PROCESS ====="
if pgrep -x sshd > /dev/null; then
  echo "[OK] sshd process exists"
else
  echo "[FAIL] sshd process not found"
fi
echo

echo "===== PORT 22 ====="
if ss -lnt | grep -q ':22 '; then
  echo "[OK] Port 22 is listening"
else
  echo "[FAIL] Port 22 is not listening"
fi
echo

echo "===== SSH LOG SAMPLE ====="
sudo journalctl -u sshd -n 5 --no-pager