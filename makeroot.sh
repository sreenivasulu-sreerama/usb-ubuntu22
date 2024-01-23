#!/bin/bash

# Adjust environment
export PATH=$PATH:/sbin:/bin
locale-gen "en_US.UTF-8"

# Adjust sources list
cat >/etc/apt/sources.list <<EOF
deb file:/ubuntu jammy main
deb http://security.ubuntu.com/ubuntu jammy main universe
EOF

# Perform update
apt clean all
apt update

# Add packages
apt install --assume-yes accountsservice/jammy
apt install --assume-yes build-essential/jammy
apt install --assume-yes dnsutils/jammy
apt install --assume-yes ssh/jammy
apt install --assume-yes telnet/jammy
apt install --assume-yes setserial/jammy
apt install --assume-yes lsof/jammy
apt install --assume-yes usbutils/jammy
apt install --assume-yes ethtool/jammy
apt install --assume-yes iptables/jammy
apt install --assume-yes ebtables/jammy
apt install --assume-yes gdisk/jammy
apt install --assume-yes dmidecode/jammy
apt install --assume-yes tcpdump/jammy
apt install --assume-yes python/jammy python-pycurl/jammy python-serial/jammy
apt install --assume-yes info/jammy lshw/jammy ntp/jammy
apt install --assume-yes zip/jammy unzip/jammy
apt install --assume-yes software-properties-common/jammy
apt install --assume-yes libqmi-utils/jammy modemmanager/jammy
sync

echo ""
echo "==========================================================="
echo " Installing Linux now. Select no disk when prompted to     "
echo " setup GRUB and exit without installing grub. The          "
echo " bootloader is setup later. Picking up incorrect disk      "
echo " may result in host system getting updated.                "
echo "==========================================================="
apt install --assume-yes linux-generic/jammy
sync

# Install extra packages
if [ -d /extrapkgs ]; then
    apt install --assume-yes /extrapkgs/*.deb
fi

# Disable setserial service as it is changing serial port configuration
systemctl disable setserial

# Redo GRUB configuration
cat >/etc/default/grub <<EOF
# Customized GRUB configuration 
GRUB_DEFAULT=0
GRUB_TIMEOUT=2
GRUB_TIMEOUT_STYLE="menu"
GRUB_DISABLE_RECOVERY="true"
GRUB_DISABLE_SUBMENU="true"
GRUB_DISABLE_OS_PROBER="true"
GRUB_TERMINAL="serial"
GRUB_SERIAL_COMMAND="serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1"
GRUB_CMDLINE_LINUX_DEFAULT="crashkernel=auto panic=2 net.ifnames=0 console=ttyS0,115200n8"
EOF

# Generate grub config now
grub-mkconfig -o /boot/grub/grub.cfg

# Open up 'root' account for login and SSH
sed -i '/^root:/s/:x:/::/' /etc/passwd
sed -i 's/^#\?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#\?PermitEmptyPasswords .*/PermitEmptyPasswords yes/' /etc/ssh/sshd_config

exit 0
