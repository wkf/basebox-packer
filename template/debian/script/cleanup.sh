# Make sure Udev doesn't block our network
# http://6.ptmc.org/?p=164
echo "cleaning up udev rules"
rm -rf /dev/.udev/
rm /lib/udev/rules.d/75-persistent-net-generator.rules

echo "Adding a 2 sec delay to the interface up, to make the dhclient happy"
echo "pre-up sleep 2" >> /etc/network/interfaces

echo "Removing any old kernels..."
apt-get purge -y $(                       \
  dpkg --list                              \
  | egrep '^ii  linux-(im|he)'             \
  | awk '{print $2}'                       \
  | grep -v `uname -r`                     \
  | egrep -v 'linux-(image|headers)-amd64' \
)

apt-get clean -y

# Clean up tmp
rm -rf /tmp/*

if [ -d "/var/lib/dhcp" ]; then
    # Remove leftover leases and persistent rules
    echo "cleaning up dhcp leases"
    rm /var/lib/dhcp/*
fi
