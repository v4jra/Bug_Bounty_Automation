#!/bin/bash
# ============================================
#  IGRIS Bug Bounty Automation Script
#  Master Recon & Scanning Workflow
# ============================================

set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <domain>"
  exit 1
fi

domain=$1
output="results/$domain"
mkdir -p $output/{subdomains,resolved,secrets,nuclei,dalfox,ports}

echo -e "\033[1;32m[+]\033[0m [1/10] Subdomain enumeration"
subfinder -d $domain -o $output/subdomains.txt || true

echo -e "\033[1;32m[+]\033[0m [2/10] Resolving"
cat $output/subdomains.txt | dnsx -silent -o $output/resolved.txt || true

echo -e "\033[1;32m[+]\033[0m [3/10] Probing live hosts"
cat $output/resolved.txt | httpx -silent -o $output/httpx.txt || true

echo -e "\033[1;32m[+]\033[0m [4/10] JS & endpoint extraction"
cat $output/httpx.txt | subjs | anew $output/js.txt || true

echo -e "\033[1;32m[+]\033[0m [5/10] Secrets & sensitive info"
if command -v gf &> /dev/null; then
  cat $output/js.txt | gf secrets | tee $output/secrets/secrets.txt
else
  echo "[!] gf not installed"
fi

if command -v trufflehog &> /dev/null; then
  trufflehog filesystem --directory=$output/js.txt --json > $output/secrets/trufflehog.json
else
  echo "[!] trufflehog not installed"
fi

echo -e "\033[1;32m[+]\033[0m [6/10] Nuclei scanning"
if command -v nuclei &> /dev/null; then
  nuclei -l $output/httpx.txt -o $output/nuclei/nuclei.jsonl
else
  echo "[!] nuclei not installed"
fi

echo -e "\033[1;32m[+]\033[0m [7/10] Dalfox XSS testing"
if command -v dalfox &> /dev/null; then
  dalfox file $output/httpx.txt -o $output/dalfox/dalfox.txt
else
  echo "[!] dalfox not installed"
fi

echo -e "\033[1;32m[+]\033[0m [8/10] Port scanning"
nmap -iL $output/resolved.txt -oN $output/ports/nmap.txt || true

echo -e "\033[1;32m[+]\033[0m [9/10] Report summary"
echo "Subdomains: $(wc -l < $output/subdomains.txt)"
echo "Resolved:   $(wc -l < $output/resolved.txt)"
echo "Live:       $(wc -l < $output/httpx.txt)"

echo -e "\033[1;32m[+]\033[0m [10/10] Enumeration finished!"
