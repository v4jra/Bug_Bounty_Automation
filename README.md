# IGRIS Bug Bounty Automation

A simple shell script to automate reconnaissance and scanning workflow for bug bounty hunting.

## Features
- Subdomain enumeration (subfinder)
- DNS resolution (dnsx)
- Live host probing (httpx)
- JS & endpoint extraction (subjs)
- Secrets detection (gf, trufflehog)
- Vulnerability scanning (nuclei)
- XSS testing (dalfox)
- Port scanning (nmap)

## Requirements
Make sure these tools are installed before running:
- [subfinder](https://github.com/projectdiscovery/subfinder)
- [dnsx](https://github.com/projectdiscovery/dnsx)
- [httpx](https://github.com/projectdiscovery/httpx)
- [subjs](https://github.com/lc/subjs)
- [gf](https://github.com/tomnomnom/gf)
- [trufflehog](https://github.com/trufflesecurity/trufflehog)
- [nuclei](https://github.com/projectdiscovery/nuclei)
- [dalfox](https://github.com/hahwul/dalfox)
- [nmap](https://nmap.org/)

## Usage
```bash
chmod +x igris.sh
./igris.sh target.com
