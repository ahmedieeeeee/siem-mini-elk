# run_siem.ps1
# PowerShell workflow to run SIEM mini-system for portfolio demo

# Step 1: Go to project folder
cd $PSScriptRoot

# Step 2: Start ELK stack in detached mode
Write-Host "Starting ELK stack..."
docker-compose up -d

# Step 3: Wait a few seconds for containers to be ready
Start-Sleep -Seconds 20

# Step 4: Generate demo logs
Write-Host "Generating demo logs..."
python .\scripts\generate_nginx.py
python .\scripts\generate_firewall.py

# Step 5: Tail Logstash logs
Write-Host "Tailing Logstash logs (press Ctrl+C to stop)..."
docker logs -f siem-mini-elk-logstash-1

# Step 6: Open Kibana dashboard in default browser
Write-Host "Opening Kibana dashboard..."
Start-Process "http://localhost:5601"


Usage:

cd "C:\Users\Ahmed Rizwan\Downloads\New folder\siem-mini-elk\siem-mini-elk"
.\run_siem.ps1


✅ This will:

Start ELK containers.

Generate demo logs.

Show Logstash logs in real-time.

Open Kibana automatically.

