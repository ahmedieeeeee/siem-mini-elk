# SIEM Mini-System Portfolio Demo

## Overview
This project demonstrates a mini SIEM (Security Information and Event Management) system using the ELK stack (Elasticsearch, Logstash, Kibana) and ElastAlert for alerts. It collects logs from multiple sources (web server, firewall) and visualizes them in Kibana with optional alerting.

---

## Step-by-Step Explanation

### 1. Start ELK Stack
```powershell
docker-compose up -d
Launches Elasticsearch, Logstash, Kibana, and ElastAlert in Docker containers.

-d runs in the background so you can continue using PowerShell.

Why: The stack is the backbone of the SIEM system, responsible for storing, processing, and visualizing logs.

2. Generate Demo Logs
powershell
Copy
Edit
python .\scripts\generate_nginx.py
python .\scripts\generate_firewall.py
Sends simulated logs to Logstash.

Why: Without logs, dashboards remain empty. Demo logs showcase how the SIEM system works.

3. Tail Logstash Logs
powershell
Copy
Edit
docker logs -f siem-mini-elk-logstash-1
Monitors logs as they are processed by Logstash in real-time.

Why: Helps verify that logs are ingested correctly before viewing them in Kibana.

4. Access Kibana Dashboard
Open:

arduino
Copy
Edit
http://localhost:5601
Visualize logs, search entries, and see dashboards.

Optionally, configure ElastAlert rules to get automated alerts.

Why: Kibana provides visualization and insight, making your SIEM project interactive and demonstrable.

5. Automated Workflow & Screenshots
To simplify running the demo and documenting it for your portfolio, use the PowerShell workflow:

powershell
Copy
Edit
.\run_siem.ps1
What this script does:

Starts ELK containers in detached mode.

Generates demo logs automatically.

Tails Logstash logs in real-time.

Opens Kibana in your default browser.

Detects all dashboards in Kibana automatically.

Takes high-resolution screenshots (1920x1080) of each dashboard.

Saves screenshots in the screenshots folder for your portfolio.

Why: This ensures the SIEM demo is reproducible and the screenshots provide visual evidence of your work without manual effort.

6. Stop the System
powershell
Copy
Edit
docker-compose down
Stops all containers.

Why: Frees up system resources and stops running services safely.

Notes
Ensure Docker Desktop is running and Linux containers are enabled.

Use run_siem.ps1 for a fully automated demo workflow.

Screenshots are stored in the screenshots folder, ready to include in your portfolio.

For portfolio presentation, you can add these screenshots directly to your GitHub repo.

yaml
Copy
Edit

---

This README now:  

1. Explains **how to run the SIEM system manually**.  
2. Explains **how to run the automated workflow** with screenshots.  
3. Makes your project **portfolio-ready**, so anyone can reproduce the demo easily.  

---
