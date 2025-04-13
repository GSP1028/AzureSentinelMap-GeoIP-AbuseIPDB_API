# --- CONFIGURATION ---
$workspaceId = "<Your_WorkspaceID>"
$sharedKey = "<Your_Primary_Key>"
$logType = "RDPAttackerTable_CL"  # This becomes the table: AbuseIPThreatIntel_CL
$jsonPath = "$env:USERPROFILE\Desktop\abuseipresults.json"

# --- FUNCTIONS ---
Function Build-Signature {
    param (
        [string]$workspaceId,
        [string]$sharedKey,
        [string]$date,
        [int]$contentLength,
        [string]$method = "POST",
        [string]$contentType = "application/json",
        [string]$resource = "/api/logs"
    )

    $xHeaders = "x-ms-date:$date"
    $stringToHash = "$method`n$contentLength`n$contentType`n$xHeaders`n$resource"
    $bytesToHash = [Text.Encoding]::UTF8.GetBytes($stringToHash)
    $keyBytes = [Convert]::FromBase64String($sharedKey)
    $hmacSha256 = New-Object System.Security.Cryptography.HMACSHA256
    $hmacSha256.Key = $keyBytes
    $hashedBytes = $hmacSha256.ComputeHash($bytesToHash)
    $encodedHash = [Convert]::ToBase64String($hashedBytes)
    return "SharedKey ${workspaceId}:$encodedHash"
}

# --- MAIN ---
$json = Get-Content -Path $jsonPath -Raw
$date = (Get-Date).ToUniversalTime().ToString("r")
$contentLength = $json.Length
$signature = Build-Signature -workspaceId $workspaceId -sharedKey $sharedKey -date $date -contentLength $contentLength

$headers = @{
    "Content-Type"  = "application/json"
    "Authorization" = $signature
    "Log-Type"      = $logType
    "x-ms-date"     = $date
    "time-generated-field" = "TimeGenerated"
}

$uri = "https://$workspaceId.ods.opinsights.azure.com/api/logs?api-version=2016-04-01"

Write-Host "Sending data to Sentinel..."

$response = Invoke-RestMethod -Method Post -Uri $uri -Headers $headers -Body $json

Write-Host "`n✅ Data sent to Sentinel!"
