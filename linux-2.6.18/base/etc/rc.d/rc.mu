#!/bin/sh

echo "-- /etc/rc.d/rc.mu --"

# start loggers
syslogd -m 0
sleep 1
klogd

# settings
setterm -blank 5

# setup network
# ifconfig eth0 1.1.1.1 netmask 255.255.255.0
# route add default gw 1.1.1.1

# start daemons
