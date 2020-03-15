#!/bin/bash
#DEPENDENCIES : apt aptdate && apt install -y nmap
#Tested on Debian OS based version (ubuntu ect.)
ipvuln=`echo "$@"`

function scanning {
	clear
	echo -e "Scanning on $ipvuln, please wait..."
	> smb3_report.txt
	nmap -p445 --script smb-protocols -Pn $ipvuln > "/tmp/scan"
	cat /tmp/scan | grep '|_    3.11' -B14 | grep "Nmap scan report for" | cut -d ' ' -f 5- > /tmp/smb3
	file="/tmp/smb3"
	while VULN= read -r IP;
	do
	clear
		echo "VULNERABLE: $IP
	-- |   Windows SMBv3 Client/Server Remote Code Execution Vulnerability
	-- |     State: POTENTIALLY VULNERABLE (if your don't have apply the patchs)
	-- |     IDs:  CVE:CVE-2020-0796
	-- |     Risk factor: VERY HIGH
	-- |       A critical remote code execution vulnerability exists in Microsoft SMB V3.1.1 (3.11):
	-- |		Windows 10 Version 1903 for 32-bit Systems
	-- |		Windows 10 Version 1903 for ARM64-based Systems
	-- |		Windows 10 Version 1903 for x64-based Systems
	-- |		Windows 10 Version 1909 for 32-bit Systems
	-- |		Windows 10 Version 1909 for ARM64-based Systems
	-- |		Windows 10 Version 1909 for x64-based Systems
	-- |		Windows Server, version 1903 (Server Core installation)
	-- |		Windows Server, version 1909 (Server Core installation)
	-- |
	-- |     Disclosure date: 03/13/2020
	-- |     Remediations :
	-- |          https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2020-0796
	-- |
	-- |     References :
	-- |       https://nvd.nist.gov/vuln/detail/CVE-2020-0796
	-- |_      https://blogs.technet.microsoft.com/msrc/2017/05/12/customer-guidance-for-wannacrypt-attacks/

			" >> smb3_report.txt
	done <"$file"
	cat smb3_report.txt
}

#regex $ipvuln is an valid IP adress
if [[ "$1" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
	scanning
else
	checkcird=`echo $ipvuln | grep "/"`
	if [[ "$checkcird" != "" ]]; then
		scanning
	else
		clear
		script="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
		echo "Usage ./$script IP_OR_CIDR-RANGE"
		echo -e "Example:
		./$script 192.168.1.0/24
		./$script 192.168.1.94
		Or multiple: ./$script 8.8.8.8 192.168.1.94"
	fi
fi
