# AzureSentinelMap-GeoIP-AbuseIPDB_API

Inspired by: [https://www.youtube.com/watch?v=RoZeVbbZ0o0](https://www.youtube.com/watch?v=g5JL2RIbThM&list=WL&index=1&t=3408s)

Azure Sentinel Honeypot home lab that grabs failed RDP logins (Event ID: 4625) from windows VM and maps attacker IPs to longitude and latitude using a dataset. Extended the home lab by running attacker IPs through the AbuseIP database API to grab the confidence score of IPs deemed abusive and mapped scores to visualize the data.

# Learning Experience:
