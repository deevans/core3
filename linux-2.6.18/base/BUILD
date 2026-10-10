
# CorePKG build script for $PKG.
# Copyright 2010-2024 David Egan Evans
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc., 59 Temple
# Place, Suite 330, Boston, MA 02111-1307 USA

DIST=deevans
PKG=base
VERSION=1

if test ! -w .
then echo 'Cannot write to this directory!' 1>&2; exit 2
fi

if ! test $(id -u) = 0
then echo This script must be run as root
fi

if test ! -f core.info
then echo "The core.info file is not present." 1>&2; exit 3
fi

if test -d /tmp/$DIST-$PKG/
then rm -r /tmp/$DIST-$PKG/
fi

mkdir -m 0755 -p /tmp/$DIST-$PKG/

# Follow the /usr/ merge from freedesktop.org:
#ln -s /usr/bin /tmp/$DIST-$PKG/sbin
ln -s /usr/bin /tmp/$DIST-$PKG/bin
#ln -s /usr/lib /tmp/$DIST-$PKG/lib

# Create a skeleton for empty directories not added by packages:
for i in boot home proc sys
do mkdir /tmp/$DIST-$PKG/$i
done
mkdir -p /tmp/$DIST-$PKG/usr/lib/modules/
mkdir -m 1777 -p /tmp/$DIST-$PKG/tmp/
mkdir -m 755 -p /tmp/$DIST-$PKG/etc/modprobe.d/

for i in cdrom floppy remote usb
do mkdir -p /tmp/$DIST-$PKG/mnt/$i
done

# /etc/mtab is removed as reinstalling core_base breaks it (use mount -af).
# This should be in the installer for the initial file. Same with the 
# ld.so.cache file. /var/locatedb is removed similarly, as updatedb will build
# it anew without warning.
cp -Rdp etc/ dev/ root/ usr/ var/ /tmp/$DIST-$PKG/
mkdir -m 700 -p /tmp/$DIST-$PKG/var/lock/
# Kernel 2.6.26 /proc/mounts is complete and should use a symlink:
# ln -s /proc/mounts /tmp/$DIST-$PKG/etc/mtab

mkdir -p /tmp/$DIST-$PKG/usr/bin/
(cd /tmp/$DIST-$PKG/usr/bin/
 ln -s /usr/bin/bash sh
)

mkdir -p /tmp/$DIST-$PKG/usr/man/man1/
echo .so man1/bash.1 > /tmp/$DIST-$PKG/usr/man/man1/sh.1
bzip2 -9 /tmp/$DIST-$PKG/usr/man/man1/sh.1

cp core.info /tmp/$DIST-$PKG/
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG/
	echo Before packaging: chown -R root: /tmp/$DIST-$PKG/
else chown -R root: /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
fi
