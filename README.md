# ssh-remarkable-refresh

**Note**: I have discontinued this project, as the user may use the IPv6 address, which is typically static, to SSH to their reMarkable instead. I set `$REMARKABLE_IPV6` to this address, and I use this script only to switch my environmental variables and configurations to the new address (using the `-n` flag). To easily swap between the USB address and IPv6 address, I've added a script under `switch_remarkable_ip.sh`. I expect this script to be more useful, but I'll leave the code for reference.

This repository provides a script to update the IP address in the SSH config file and the SSH private key configuration on the user's laptop. The script identifies the IP address on the local network via the tablet's MAC address.

## Prerequisites

- `nmap`
- `ipcalc`

## Installation

Clone the repository and navigate to the directory:

```sh
git clone https://github.com/matthewgomezcullen/ssh-remarkable-refresh.git
cd ssh-remarkable-refresh
```

## Usage

There are many guides for connecting to a user's reMarkable tablet via SSH (see [this guide](https://remarkable.guide/guide/access/ssh.html) for an example).

Typically, these guides recommend connecting to the reMarkable via a USB cable or over Wi-Fi. Over a USB cable, the user may SSH to their tablet with:

```sh
ssh root@10.11.99.1
```

Over Wi-Fi, the guides recommend that the user checks the IP address (Settings -> Help -> About -> Copyrights and licenses -> Under GPLv3 Compliance) and use this IP address to connect to the tablet, via:

```sh
ssh root@<ip_address>
```

To simplify this process, it is recommended that the user adds:

```sh
Host remarkable
  Hostname <ip_address>
  User root
  ...
```

to their `~/.ssh/config` file, and SSH public and private keys to their computer and reMarkable (see the above guide for more detail). However, these guides often fail to address the fact that the IP address of the user's tablet may change upon reconnecting with the Wi-Fi, which breaks these configurations.

### Running the Script

To update the IP address in your SSH config file, run:

```sh
./refresh_rmrk.sh -m <remarkable_mac>
```

or set $REMARKABLE_MAC for repeated use (**recommended**).

### Options

- `-m, --mac`: Set the reMarkable MAC address (default: `$REMARKABLE_MAC`)
- `-i, --new_ip`: Set the previous reMarkable IP address used in configurations (default: `$REMARKABLE_IP`)
- `-u, --usb`: Use USB connection (default: false)
- `-c, --config`: Set the SSH config file (default: `~/.ssh/config`)
- `-k, --known-hosts`: Set the known hosts file (default: `~/.ssh/known_hosts`)
- `-h, --help`: Display the help message

### Example

To update the IP address using the MAC address of your reMarkable tablet:

```sh
./refresh_rmrk.sh -m AA:BB:CC:DD:EE:FF
```

To switch between USB and IPv6 addresses:

```sh
./switch_rmrk.sh -i <ipv6_address> -u
```

## Troubleshooting

If you encounter any issues, please check the following:

- Ensure `nmap` and `ipcalc` are installed.
- Verify that the MAC address is correct.
- Check the network connection of your reMarkable tablet.

*Disclaimer: Use at your own risk.*
