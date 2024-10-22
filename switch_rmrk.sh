#!/bin/bash

# Default values
ipv6=$REMARKABLE_IPV6
usb=false
config="$HOME/.ssh/config"
known_hosts="$HOME/.ssh/known_hosts"

# Create the config string template
config_template="Host remarkable\n  Hostname %s\n  User root"

# Function to display help
show_help() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -i, --ip            Set the reMarkable IPv6 address (default: \$REMARKABLE_IP)"
    echo "  -u, --usb           Use USB connection (default: false)"
    echo "  -c, --config        Set the SSH config file (default: $HOME/.ssh/config)"
    echo "  -k, --known-hosts   Set the known hosts file (default: $HOME/.ssh/known_hosts)"
    echo "  -h, --help          Display this help message"
}

# Parsing args
while [ $# -gt 0 ]; do
    case "$1" in
        -i|--ip)
            ipv6="$2"
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

# Get the directory of the current script
script_dir=$(cd "$(dirname "$0")" && pwd)

# Construct the source command
script="$script_dir/refresh_rmrk.sh"

# Execute the source command
if [ "$usb" = true ]; then
    source $script -u -n $ipv6 -c $config -k $known_hosts
else;
    source $script -n $ipv6 -c $config -k $known_hosts
fi