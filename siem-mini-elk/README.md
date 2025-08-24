# SIEM Mini-System (ELK + Python)

A portfolio-ready **mini SIEM** that ingests web and firewall logs, parses and indexes them into **Elasticsearch**, visualizes in **Kibana**, and raises **real-time alerts** using **Elastalert2**.

## Stack
- **Elasticsearch 7.17** (single-node, security disabled for local dev)
- **Kibana 7.17**
- **Logstash 7.17** (parses Nginx-like access logs + simple firewall logs)
- **Elastalert2** (alerting with ready-made rules)
- **Python** log generators for demo data

> ⚠️ This project is for learning/demo. Do **not** use this exact config in production.

---

## Quick Start

### 1) Prereqs
- Docker + Docker Compose
- Python 3.8+ (only for generating demo logs)

### 2) Spin up the stack
```bash
docker compose up -d
# Wait ~30s for Elasticsearch + Kibana + Logstash + Elastalert to start
```

### 3) Generate demo logs
In a new terminal:
```bash
# Nginx-like access logs
docker compose exec logstash bash -lc "python3 /usr/share/logstash/pipeline/../.. 2>/dev/null || true"
```

Alternatively, run the bundled scripts from your host (they write into the mounted ./data directory):
```bash
python3 scripts/generate_nginx.py
python3 scripts/generate_firewall.py
```

### 4) Create Kibana index patterns
Open Kibana at <http://localhost:5601> → **Stack Management → Index Patterns** and add:
- `weblogs-*`
- `firewall-*`

Now use **Discover** and **Visualize** to build dashboards (requests by status, top IPs, actions over time, etc.).

### 5) See alerts
Elastalert2 reads from Elasticsearch and logs alerts to its container logs.
```bash
docker compose logs -f elastalert
```
You should see:
- **Many 404s from single IP** (frequency rule)
- **Possible port scan - many destination ports** (cardinality rule)

---

## Repo Structure
```
.
├─ alerts/
│  ├─ config.yaml
│  └─ rules/
│     ├─ 404_threshold.yaml
│     └─ portscan.yaml
├─ data/
│  ├─ firewall/
│  └─ nginx/
├─ docs/
│  └─ portfolio-notes.md
├─ logstash/
│  └─ pipeline/
│     └─ pipeline.conf
├─ scripts/
│  ├─ generate_firewall.py
│  └─ generate_nginx.py
└─ docker-compose.yml
```

---

## How It Works
- **Logstash** tails files under `./data/nginx/*.log` and `./data/firewall/*.log` and parses them with **grok**.
- Parsed events go to two indices: `weblogs-YYYY.MM.DD` and `firewall-YYYY.MM.DD`.
- **Kibana** visualizes and dashboards these indices.
- **Elastalert2** runs two rules:
  - `404_threshold.yaml`: triggers when an IP causes many 404s within 1 minute.
  - `portscan.yaml`: triggers when a source IP hits many **unique destination ports** in 1 minute.

---

## Upgrade Ideas (great for your portfolio)
- Add a **Beats** shipper (Filebeat) and use module pipelines.
- Add **GeoIP** enrichment + world map visualization.
- Send alerts to **Slack/Email** (Elastalert alert types).
- Add a **Docker healthcheck** and dashboards export (`.ndjson`).
- Add unit tests for Logstash grok patterns with `logstash-filter-verifier`.
- Package the demo scripts as a small **CLI** with `argparse`.

---

## License
MIT
