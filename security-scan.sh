
#!/bin/bash

# Automated Cloud Security Scan
# Run from the project root directory

set -u

REPORT_DIR="security/reports"
mkdir -p "$REPORT_DIR"

echo "=================================="
echo " Starting Automated Security Scan"
echo "=================================="

echo "[1/3] Running Bandit..."
bandit -r app/ -f json -o "$REPORT_DIR/bandit-report.json"
echo "Bandit report generated."

echo "[2/3] Running pip-audit..."
pip-audit -f json -o "$REPORT_DIR/dependency-report.json"
echo "Dependency report generated."

echo "[3/3] Running Gitleaks..."
gitleaks dir . \
  --report-format json \
  --report-path "$REPORT_DIR/gitleaks-report.json" \
  --exit-code 0
echo "Gitleaks report generated."

echo "=================================="
echo " Automated Security Scan Completed"
echo " Reports saved in $REPORT_DIR"
echo "=================================="
