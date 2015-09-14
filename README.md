# perl-netwalk
This utility utilizes snmpwalk to gather ARP databases from your network devices and creates reports based on vendor MAC addresses.  Output report is generated as HTML.  This is useful for locating unauthorized devices across your enterprise wide area network. 


## Inputs
* **$WORKDIR** = desired location for **rawoutput** and **index.html**
* **$SNMPWALKPATH** = path to ucd-snmp implementation of snmpwalk
* **$FINALWWW** = path to final destination for **arpscan.pl** to create web report


## Outputs
* **index.html** = web report that displays Location, IP Address, DNS PTR record, and device manufacturer

## Instructions
1. copy **vendormacsx.txt** file to your **$WORKDIR**
2. copy **routerlist.txt** file to your **$WORKDIR** and update with your network devices
3. In **arpscan.pl**, verify your SNMP OID path to the arp table.  Cisco OID path to arp table as an example.
4. In **arpscan.pl**, locate '$dnsname' and update with your desired DNS server.  10.10.5.10 used as an example.
4. create CRONTAB entry to run **arpscan.pl** as often as you like (5 minute interval recommended)

