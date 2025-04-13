# Define output file path
$outputFile = "C:\Path\to\your\RDPAttackerIPS.txt"

# Get all Event ID 4625 logs
$events = Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4625} -ErrorAction SilentlyContinue

# Extract and deduplicate IPs
$ips = $events | ForEach-Object {
    [xml]$xml = $_.ToXml()
    $ip = $xml.Event.EventData.Data | Where-Object { $_.Name -eq "IpAddress" } | Select-Object -ExpandProperty '#text'
    if ($ip -and $ip -ne "-" -and $ip -ne "127.0.0.1" -and $ip -ne "::1") {
        $ip
    }
} | Sort-Object -Unique

# Write unique IPs to file
$ips | Out-File -FilePath $outputFile -Encoding ASCII

Write-Output "Saved $($ips.Count) unique IPs to: $outputFile"