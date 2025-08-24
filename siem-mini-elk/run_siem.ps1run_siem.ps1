# run_siem.ps1
# PowerShell workflow to run SIEM mini-system and auto-screenshot all dashboards

cd $PSScriptRoot

# Step 1: Start ELK stack
Write-Host "Starting ELK stack..."
docker-compose up -d

# Step 2: Wait for containers to start
Write-Host "Waiting for ELK containers to start..."
Start-Sleep -Seconds 30

# Step 3: Generate demo logs
Write-Host "Generating demo logs..."
python .\scripts\generate_nginx.py
python .\scripts\generate_firewall.py

# Step 4: Tail Logstash logs in background
Start-Process powershell -ArgumentList "docker logs -f siem-mini-elk-logstash-1"

# Step 5: Open Kibana in default browser
$kibanaUrl = "http://localhost:5601"
Write-Host "Opening Kibana dashboard..."
Start-Process $kibanaUrl

# Step 6: Wait for Kibana to fully load
Write-Host "Waiting for Kibana to load..."
Start-Sleep -Seconds 20

# Step 7: Create screenshots folder
$screenshotFolder = "$PSScriptRoot\screenshots"
if (-Not (Test-Path $screenshotFolder)) {
    New-Item -ItemType Directory -Path $screenshotFolder
}

# Step 8: Paths for Chrome
$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"  # Adjust if needed

# Step 9: Get all dashboard IDs via Kibana API
# Requires default Kibana API endpoint; no authentication assumed
try {
    $dashboardsJson = Invoke-RestMethod -Uri "$kibanaUrl/api/saved_objects/_find?type=dashboard&per_page=100" -Method GET -Headers @{
        "kbn-xsrf" = "true"
    }

    $dashboardIds = $dashboardsJson.saved_objects.id
    Write-Host "Found dashboards: $($dashboardIds -join ', ')"
} catch {
    Write-Host "Failed to fetch dashboards. Make sure Kibana is running and accessible."
    exit
}

# Step 10: Take screenshots of each dashboard
foreach ($id in $dashboardIds) {
    $dashUrl = "$kibanaUrl/app/dashboards#/view/$id"
    $fileName = "$screenshotFolder\dashboard_$id.png"

    & $chromePath --headless --disable-gpu --window-size=1920,1080 --screenshot="$fileName" $dashUrl
    Write-Host "Screenshot saved: $fileName"
}

Write-Host "All screenshots saved in the 'screenshots' folder."
✅ How it works
Starts ELK containers in detached mode.

Generates demo logs so dashboards have data.

Tails Logstash logs for monitoring.

Opens Kibana in the default browser.

Calls Kibana API to fetch all saved dashboard IDs.

Uses Chrome headless to take screenshots for each dashboard automatically.

Saves screenshots in the screenshots folder, ready for your portfolio.

Notes / Requirements
Chrome must be installed and path correct ($chromePath).

Kibana must be running at http://localhost:5601.

For production, you may need authentication headers if Kibana requires login.

Screenshots are high resolution (1920x1080) by default.

