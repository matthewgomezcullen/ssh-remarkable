# ssh-remarkable
There are many guides for connecting to a user's reMarkable tablet via SSH (see https://remarkable.guide/guide/access/ssh.html for an example).

Typically, these guides recommend connecting to the reMarkable via a USB cable or over Wi-Fi. Over a USB cable, the user may SSH to their tablet with
```
ssh root@10.11.99.1
```

Over Wi-Fi, the guides recommend that the user checks the IP address (Settings -> Help -> About -> Copyrights and licenses -> Under GPLv3 Compliance) and use this IP address to connect to the tablet, via
```
ssh root@<ip_address>
```

To simplify this process, it is recommended that the user adds
```
user remarkable
  Hostname <ip_address>
  User root
  ...
```
to their `~/.ssh/config` file, and SSH public and private keys to their computer and reMarkable (see the above guide for more detail). However, these guides often fail to address the fact that the IP address of the user's tablet may change upon reconnecting with the Wi-Fi, which breaks these configurations.

This repository provides a script to update the IP address in the SSH config file and the SSH private key configuration on the user's laptop. The script identifies the IP address on the local network via the tablet's MAC address.

**Note**: I have discontinued this project, as the user may use the IPv6 address, which is typically static, to SSH to their reMarkable instead. I set $REMARKABLE_IPV6 to this address, and I use this script only to switch my environmental variables and configurations to the new address (using the `-n` flag). To easily swap between the USB address and IPv6 address, I've added a script under `switch_remarkable_ip.sh`. I expect that this script will be more useful, but I'll leave the code for identifying a device from its MAC address in case it is useful to anyone.

# Installation

Run
```
brew install ifconfig ipcalc
```
for pre-requisites.

Add
```
export $REMARKABLE_MAC=<remarkable_mac_address>
alias refresh_rmrk = <path/to/ssh-refresh-rmrk>
```
to your bash/zsh config file. Follow the guide provided to find the MAC address (below the IP address). **Note**, keep it capitalised.

## Run

Run
```
refresh_rmrk
```

The script may require the user to enter their passwor to scan the network for MAC addresses.

# Notes

- The network may block IPv6 connections. If this is the case, the user must use either a USB cable or the IPv4 (standard) IP address.

---

**Disclaimer**: use this at your own risk.