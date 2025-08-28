import json
import sys
import tempfile
import os

tf_output = json.load(sys.stdin)
clusters = tf_output["clusters_creds"]["value"]

inventory = {"all": {"hosts": {}, "children": {}}}

for cluster_name, cluster in clusters.items():
    fd, key_path = tempfile.mkstemp(prefix="{}_".format(cluster_name), suffix=".pem")
    os.write(fd, cluster["private_key_pem"].encode())
    os.close(fd)
    os.chmod(key_path, 0o600)

    inventory["all"]["hosts"][cluster_name + "-master"] = {
        "ansible_host": cluster["master_ip"],
        "ansible_user": cluster["admin_username"],
        "ansible_private_key_file": key_path,
    }

    for worker in cluster["worker_ips"]:
        inventory["all"]["hosts"][worker["name"]] = {
            "ansible_host": worker["public_ip"],
            "ansible_user": cluster["admin_username"],
            "ansible_private_key_file": key_path,
        }

print(json.dumps(inventory, indent=2))
