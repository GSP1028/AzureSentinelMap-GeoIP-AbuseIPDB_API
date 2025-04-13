# AzureSentinelMap-GeoIP-AbuseIPDB_API

Inspired by: [https://www.youtube.com/watch?v=RoZeVbbZ0o0](https://www.youtube.com/watch?v=g5JL2RIbThM&list=WL&index=1&t=3408s)

Azure Sentinel Honeypot home lab that grabs failed RDP logins (Event ID: 4625) from windows VM and maps attacker IPs to longitude and latitude using a dataset. Extended the home lab by running attacker IPs through the AbuseIP database API to grab the confidence score of IPs deemed abusive and mapped scores to visualize the data.

# Learning Experience:

1. Basic Cloud Infrastructure and Virtualization
Learned the basics of how to setup cloud infrastructure elements and how to navigate through the Azure portal. Gained experience in configuring VMs inside of Azure, in this case Windows VM.
2. Network Security Groups
Configured network secuirty groups to manage inbound and outbound rules for the virtual windows machine. Through this configuration I learned how to setup the honeypot Windows VM traffic rules and allow attackers to brute force RDP the VM. This showed me the importance of proper network configuration and attacker behaivor.
3. Azure Sentinel Setup (SIEM)
Configured Azure Sentinel gaining knowledge into how SIEMs collect and analyze security logs and data. Setup the Log Analytics Workspace to ingest and analyze security data from the VM.
4. Windows Security and Log Management
Setup the collection of Windows security event logs through Azure AMA in the Log Analytics Workspace. Configured Microsoft Defender to allow for inbound traffic in order for the honeypot to work. Through this I learned the importance of Microsoft Defender configuration and how it increases the security posture of cloud and hybrid enviornments.
5. Geolocation and Data Vizualation
Using a dataset in Sentinel Watchlist I learned how to integrate data for mapping of attcker IPs to longitude and latitude geolocation. Learned how Kusto Query Language can be used to visualize logs and how it can map attacker IPs on to a geo-map. Then saved the Query into a Sentinel  Workbook for ease of use. This taught me how to enrich log data to see geographic information, which is important for understanding the source of threats.

# Extension

1. AbuseIPDB
I learned how to use the AbuseIP database API in order to cross reference attacker IPs. This gave me an Abuse Confidence Score and other important information such as the Internet Service Providers and Countries of the attackers. Then using the knowledge I gained in the earlier home lab I mapped the attacker IPs on to a geo-map. Then I set the map up to show countries with higher average Abuse Confidence Scores in red. This process taught me how third-party API's can be used to show the reputation of attacker IPs and improve the overall threat intelligence of a SIEM.
2. PowerShell Scripting
This extension to the lab taught me how to use PowerShell scripting for third-party API GET requests and POST requests for sending data to Azure. I first wrote a script in order to grab all IPs with Event ID 4625 and saved it into a text file with no duplicate addresses. The next script used the AbuseIPDB API in order to check the attacker IP text list and write to a new JSON file with data such as AbuseConfidenceScore and ISP. The final script sent this JSON file to the Azure through a POST request while requiring authentication headers. This taught me how PowerShell scripting can be used in order to gather and manipulate data through APIs which improves the security posture of your infrastructure.
3. Task Scheduler
Finally, after all the scripts were tested and working as intended I assigned them to the task scheduler. I wrote anothe Powershell script that ran each of the three other scripts sequentially. Then I went into the VM and assigned this script to run every 6 hours daily. This taught me how tasks can be automated in security and how this can make the jobs of SOC analysts and security engineers easier through automation.

# Geolocation Map of RDP Attackers


![Screenshot 2025-04-12 210953](https://github.com/user-attachments/assets/9c2b5530-899a-4a7c-a5de-ccebba257271)

