# SIEM Mini-System Portfolio Demo

## Overview
This project demonstrates a mini SIEM (Security Information and Event Management) system using the ELK stack (Elasticsearch, Logstash, Kibana) and ElastAlert for alerts. It collects logs from multiple sources (web server, firewall) and visualizes them in Kibana with optional alerting.

---

## Step-by-Step Explanation

### 1. Start ELK Stack
```powershell
docker-compose up -d

2. Generate Demo Logs
python .\scripts\generate_nginx.py
python .\scripts\generate_firewall.py


Sends simulated logs to Logstash.
Visualize logs, search entries, and see dashboards.

Optionally, configure ElastAlert rules to get automated alerts.

Why: Kibana provides visualization and insight, making your SIEM project interactive and demonstrable.

