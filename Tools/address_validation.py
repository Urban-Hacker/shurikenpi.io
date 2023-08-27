import sys
import coinaddrvalidator

def help():
    print("Script to validate a bitcoin address")
    print("Usage: address_validation [bitcoin_address]")

if (len(sys.argv) != 2):
    print("Error: Too many argument or missing argument")
    print("Use -h to display help")
    exit(1)

if sys.argv[1] == "-h" or sys.argv[1] == "--help":
    help()
    exit(0)

address = sys.argv[1]

if coinaddrvalidator.validate('btc', address).valid == True:
    print("Address valid")
    exit(0)
print("Address not valid")
exit(1)