# === CONFIGURATION ===
$apiKey = "<YOUR_API_KEY>"
$outputFile = "C:\Path\To\Your\abuseipresults.json"
$inputFile   = "C:\Path\To\Your\RDPAttackerIPS.txt"

# --- INIT ---
$results = @()
$ips = Get-Content -Path $inputFile | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" } | Select-Object -Unique

Write-Host "`n[*] Loaded $($ips.Count) unique IPs:"
$ips | ForEach-Object { Write-Host " - $_" }

# --- QUERY ABUSEIPDB ---
foreach ($ip in $ips) {
    Write-Host "`nQuerying IP: $ip"

    if (-not ($ip -match '^(\d{1,3}\.){3}\d{1,3}$')) {
        Write-Warning "Invalid IP address format: $ip"
        continue
    }

    try {
        $response = Invoke-RestMethod -Uri "https://api.abuseipdb.com/api/v2/check?ipAddress=$ip&maxAgeInDays=90" `
            -Headers @{Key = $apiKey; Accept = 'application/json'} `
            -Method GET

        $record = [PSCustomObject]@{
            TimeGenerated        = (Get-Date).ToString("s")
            IpAddress            = $ip
            AbuseConfidenceScore = $response.data.abuseConfidenceScore
            CountryCode          = $response.data.countryCode
            ISP                  = $response.data.isp
        }

        $results += $record
        Start-Sleep -Milliseconds 1200
    }
    catch {
        Write-Warning "Failed to query ${ip}: $_"
    }
}

# --- SAVE TO JSON ---
if ($results.Count -gt 0) {
    $results | ConvertTo-Json -Depth 2 | Out-File -FilePath $outputFile -Encoding UTF8
    Write-Host "`n✅ Done! JSON saved to: $outputFile"
} else {
    Write-Warning "`n⚠️ No results saved. All queries may have failed."
}