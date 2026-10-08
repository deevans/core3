#!/bin/sh

echo "-- /etc/rc.d/rc.ha $1 --"

# kill everything
killall5 -15
sleep 1
killall5 -9
sleep 1

# disable swap
swapoff -a

# unmount filesystems
sync
umount -av

# halt/reboot
$1 -f
