# ssh-remarkable
There are many guides for connecting to a user's reMarkable tablet via SSH (see https://remarkable.guide/guide/access/ssh.html for an example).

Typically, these guides recommend connecting to the reMarkable via a USB cable or over Wi-Fi. Over a USB cable, the user may SSH to their tablet with
```
ssh root@10.11.99.1
```

Over Wi-Fi, the guides recommend that the user checks the IP address (Settings -> Help -> About -> Copyrights and licenses -> Under GPLv3 Compliance) and 
use this IP address to connect to the tablet, via
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
to their `~/.ssh/config` file, and SSH public and private keys to their computer and reMarkable (see the above guide for more detail). However, these 
guides often fail to address the fact that the IP address of the user's tablet may change upon reconnecting with the Wi-Fi, which breaks these 
configurations.

This package provides an improved Bash script for connecting to the user's remarkable.
