#!/usr/bin/env python3
import random, time, os

logfile = "/data/firewall/firewall.log" if os.path.exists("/data/firewall") else "./data/firewall/firewall.log"
os.makedirs(os.path.dirname(logfile), exist_ok=True)

src_scan_ip = "192.0.2.10"
dst = "10.0.0.5"

def line(src, dst, spt, dpt, action, proto="TCP"):
    return f"FIREWALL: src={src} dst={dst} spt={spt} dpt={dpt} action={action} proto={proto}\n"

with open(logfile, "a") as f:
    # benign traffic
    for _ in range(50):
        f.write(line(f"203.0.113.{random.randint(2,50)}", dst, random.randint(1024,65535), random.choice([22,80,443,53]), random.choice(["ACCEPT","DROP"])))
        time.sleep(0.005)

    # port scan burst from one IP to trigger alert
    for port in range(20, 70):  # 50 unique ports
        f.write(line(src_scan_ip, dst, random.randint(1024,65535), port, "DROP"))
        time.sleep(0.005)

print(f"Wrote sample firewall logs to {logfile}")
