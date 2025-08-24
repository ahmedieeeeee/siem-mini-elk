#!/usr/bin/env python3
import random, time, os, sys, datetime

paths = [
    "/", "/login", "/logout", "/admin", "/products", "/products/1", "/products/2",
    "/cart", "/search?q=test", "/api/v1/items", "/nonexistent", "/favicon.ico"
]
agents = [
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36",
    "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15",
    "curl/7.64.1",
    "Wget/1.20.3 (linux-gnu)"
]
ips = ["192.0.2.%d" % i for i in range(2,30)] + ["203.0.113.%d" % i for i in range(2,30)]

logfile = os.environ.get("NGINX_LOG", "/workspace/data/nginx/access.log")
logfile = "/data/nginx/access.log" if os.path.exists("/data/nginx") else logfile
os.makedirs(os.path.dirname(logfile), exist_ok=True)

def combined(ip, path, status, size, ref, agent):
    now = datetime.datetime.utcnow().strftime("%d/%b/%Y:%H:%M:%S +0000")
    # ip - - [ts] "GET /path HTTP/1.1" 200 123 "-" "agent"
    return f'{ip} - - [{now}] "GET {path} HTTP/1.1" {status} {size} "{ref}" "{agent}"\n'

with open(logfile, "a") as f:
    for _ in range(500):
        ip = random.choice(ips)
        path = random.choice(paths)
        # bias: some 404s on /nonexistent
        status = 404 if path == "/nonexistent" and random.random() < 0.8 else random.choices([200,301,401,403,500,404],[0.65,0.05,0.05,0.05,0.05,0.15])[0]
        size = random.randint(100, 5000)
        ref = "-" if random.random() < 0.7 else "https://example.com/"
        agent = random.choice(agents)
        f.write(combined(ip, path, status, size, ref, agent))
        # small delay to ensure new lines are picked
        time.sleep(0.01)

print(f"Wrote sample access logs to {logfile}")
