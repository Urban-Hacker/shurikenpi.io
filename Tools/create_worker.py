import sys
import os

known_pools = ["public-pool.io", "solo.ckpool.org", "custom"]

def get_mining_parameters(pool, address):
    if pool == "public-pool.io":
        return "-a sha256d -o stratum+tcp://public-pool.io:21496 -u " + address
    if pool == "solo.ckpool.org":
        return "-a sha256d -o stratum+tcp://solo.ckpool.org:3333 -u " + address
    
    # Special case when using custom pool
    return "-a sha256d -o " + pool + " -u " + address

# Officially we do not support anything else except raspberry pi.
# But we have a fallback in case people want to test on their machine
miner = "arm64_cpuminer"
if "x86_64" in os.uname()[4].lower():
    miner = "x86_cpuminer"

command = "../Bin/" + miner + " " + get_mining_parameters(sys.argv[1], sys.argv[2])
print(command)