#!/bin/bash

# Default values
remarkable_mac=$REMARKABLE_MAC
new_ip=""
prev_ip=$REMARKABLE_IP
usb=false
config="$HOME/.ssh/config"
known_hosts="$HOME/.ssh/known_hosts"

# Create the config string template
config_template="Host remarkable\n  Hostname %s\n  User root"

# Function to display help
show_help() {
	echo "Usage: $0 [options]"
	echo "Options:"
	echo "  -m, --mac           Set the reMarkable MAC address (default: \$REMARKABLE_MAC)"
	echo "  -i, --ip            Set the previous reMarkable IP address used in configurations \
(default: \$REMARKABLE_IP)"
	echo "  -n, --new-ip        Skip searching for a new IP. Use this instead. (default: \
\$REMARKABLE_MAC)"
	echo "  -u, --usb           Use USB connection (default: false)"
	echo "  -c, --config        Set the SSH config file (default: $HOME/.ssh/config)"
	echo "  -k, --known-hosts   Set the known hosts file (default: $HOME/.ssh/known_hosts)"
	echo "  -h, --help          Display this help message"
}

# Parsing args
while [ $# -gt 0 ]; do
	case "$1" in
		-m|--mac)
			remarkable_mac="$2"
			shift 2
			;;
		-i|--ip)
			prev_ip="$2"
			shift 2
			;;
		-n|--new-ip)
			new_ip="$2"
			shift 2
			;;
		-u|--usb)
			usb=true
			shift
			;;
		-c|--config)
			config="$2"
			shift 2
			;;
		-k|--known-hosts)
			known_hosts="$2"
			shift 2
			;;
		-h|--help)
			show_help
			exit 0
			;;
		*)
			echo "Unknown option: $1"
			show_help
			exit 1
			;;
	esac
done

# Determine the user's shell startup script
case "$SHELL" in
	*/bash)
		startup_script="$HOME/.bashrc"
		;;
	*/zsh)
		startup_script="$HOME/.zshrc"
		;;
	*/ksh)
		startup_script="$HOME/.kshrc"
		;;
	*/fish)
		startup_script="$HOME/.config/fish/config.fish"
		;;
	*)
		echo "Unsupported shell: $SHELL"
		exit 1
		;;
esac

# Check if remarkable_mac is set
if [ -z "$remarkable_mac" ]; then
	echo "Error: reMarkable MAC address is not set."
	show_help
	exit 1
fi

# Check if prev_ip is set
if [ -z "$prev_ip" ]; then
	echo "Warning: reMarkable IP address is not set. Will add the default host configuration to \
config and will not update any IP address in the known_hosts file."
fi

if [ "$usb" = true ]; then
	new_ip="10.11.99.1"
elif [ -z "$new_ip" ]; then
	# Get the current network's IP address and subnet mask
	network_ip=$(ifconfig en0 | grep "inet " | awk '{print $2}')
	subnet_mask=$(ifconfig en0 | grep "netmask " | awk '{print $4}')

	# Convert the mask from hex to decimal (e.g., 0xffffff00 to 255.255.255.0)
	subnet_mask_dec=$(printf '%d.%d.%d.%d\n' $(echo ${subnet_mask:2} | sed 's/../0x& /g'))

	# Calculate the subnet and combine with the network IP
	cidr=$(ipcalc -n $network_ip $subnet_mask_dec | grep "Network" | awk '{print $2}')

	echo "Searching for $REMARKABLE_MAC in $cidr..."

	prev_ip=$(
		sudo nmap -sn $cidr | grep -B 2 $remarkable_mac | grep "Nmap scan report" | awk '{print $5}'
	)

	if [ -z "$prev_ip" ]; then
		echo "Could not find reMarkable on the network."
		exit 1
	else
		new_ip=$prev_ip
	fi
fi

# Export the IP to REMARKABLE_IP
export REMARKABLE_IP=$new_ip

# Add or replace the export line in the user's shell startup script
if grep -q "^export REMARKABLE_IP=" "$startup_script"; then
	sed -i '' "s/^export REMARKABLE_IP=.*/export REMARKABLE_IP=$new_ip/" "$startup_script"
else
	echo "export REMARKABLE_IP=$new_ip" >> "$startup_script"
fi

if [ -z "$prev_ip" ]; then
	# Format the config string with the IP and add to the config file
	config_string=$(printf "$config_template" "$new_ip")
	echo -e $config_string >> $config
else
	# Replace the previous IP address in known_hosts and config with the new IP address
	sed -i '' "s/$prev_ip/$new_ip/g" $config
	sed -i '' "s/^$prev_ip/$prev_ip/" "$known_hosts"
fi
