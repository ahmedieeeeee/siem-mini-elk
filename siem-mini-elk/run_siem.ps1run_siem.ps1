# run_siem.ps1
# PowerShell workflow to run SIEM mini-system and take dashboard screenshots

cd $PSScriptRoot

# Step 1: Start ELK stack
Write-Host "Starting ELK stack..."
docker-compose up -d

# Wait for containers to fully start
Start-Sleep -Seconds 30

# Step 2: Generate demo logs
Write-Host "Generating demo logs..."
python .\scripts\generate_nginx.py
python .\scripts\generate_firewall.py

# Step 3: Tail Logstash logs in background (optional)
Start-Process powershell -ArgumentList "docker logs -f siem-mini-elk-logstash-1"

# Step 4: Open Kibana dashboard in default browser
$kibanaUrl = "http://localhost:5601"
Write-Host "Opening Kibana dashboard..."
Start-Process $kibanaUrl

# Step 5: Wait for Kibana to fully load
Write-Host "Waiting for Kibana to load..."
Start-Sleep -Seconds 20

# Step 6: Take screenshots using Chrome headless
$screenshotFolder = "$PSScriptRoot\screenshots"

# Make sure folder exists
if (-Not (Test-Path $screenshotFolder)) {
    New-Item -ItemType Directory -Path $screenshotFolder
}

# Paths for Chrome
$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"  # Adjust if needed

# List of dashboards to capture (URLs)
$dashboards = @(
    "http://localhost:5601/app/dashboards#/view/your-nginx-dashboard-id",
    "http://localhost:5601/app/dashboards#/view/your-firewall-dashboard-id"
)

foreach ($dash in $dashboards) {
    $fileName = $dash -replace '[^a-zA-Z0-9]', '_' + ".png"
    & $chromePath --headless --disable-gpu --window-size=1920,1080 --screenshot="$screenshotFolder\$fileName" $dash
    Write-Host "Screenshot saved: $fileName"
}

Write-Host "All done! Screenshots are in the 'screenshots' folder."
