#!/usr/bin/env python3
import json
import sys
import tempfile
import os
import argparse

parser = argparse.ArgumentParser(
    description="Generate Ansible inventory from Terraform output"
)
parser.add_argument(
    "--output-dir",
    type=str,
    default=os.path.join(os.path.dirname(__file__), "..", "terraform", "artifacts"),
    help="Directory to write inventory files",
)
args = parser.parse_args()
output_dir = os.path.abspath(args.output_dir)
os.makedirs(output_dir, exist_ok=True)


tf_output = json.load(sys.stdin)
clusters = tf_output["clusters_creds"]["value"]

for cluster_name, cluster in clusters.items():
    lines = []

    fd, key_path = tempfile.mkstemp(suffix=".pem")
    os.write(fd, cluster["private_key_pem"].encode())
    os.close(fd)
    os.chmod(key_path, 0o600)

    lines.append("[master]")
    master_ip = cluster["master_ip"]
    master_name = cluster_name + "-master"
    lines.append(
        "%s ansible_host=%s ansible_user=%s ansible_ssh_private_key_file=%s ansible_ssh_common_args='-o IdentitiesOnly=yes'"
        % (master_name, master_ip, cluster["admin_username"], key_path)
    )

    lines.append("")

    lines.append("[workers]")
    for worker in cluster["worker_ips"]:
        worker_name = worker["name"]
        worker_ip = worker["public_ip"]
        lines.append(
            "%s ansible_host=%s ansible_user=%s ansible_ssh_private_key_file=%s ansible_ssh_common_args='-o IdentitiesOnly=yes'"
            % (worker_name, worker_ip, cluster["admin_username"], key_path)
        )
    lines.append("")

    filename = os.path.join(output_dir, "inventory_" + cluster_name + ".ini")
    with open(filename, "w") as f:
        f.write("\n".join(lines))

    print("Generated inventory for cluster '%s': %s" % (cluster_name, filename))
