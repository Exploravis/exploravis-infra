#!/usr/bin/env python3
import json
import sys


tf_output = json.load(sys.stdin)
clusters = tf_output["clusters_creds"]["value"]

for _, cluster in clusters.items():
    master_ip = cluster["master_ip"]
    print(master_ip)
