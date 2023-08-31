import sys

known_pools = ["public-pool.io", "solo.ckpool.org", "custom"]

def get_mining_parameters(pool, address):
    if pool == "public-pool.io":
        return "-a sha256d -o stratum+tcp://public-pool.io:21496 -u " + address
    if pool == "solo.ckpool.org":
        return "-a sha256d -o stratum+tcp://solo.ckpool.org:3333 -u " + address
    
    # Special case when using custom pool
    return "-a sha256d -o " + pool + " -u " + address

command = "../Bin/cpuminer " + get_mining_parameters(sys.argv[1], sys.argv[2])
print (command)
#if sys.argv[1] == "-h" or sys.argv[1] == "--help":