# CorePKG build script for ppp.
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
PKG=ppp
VERSION=2.4.5
ARCH=pentium3
TARGET=i686

if test ! -w .
then echo 'Cannot write to this directory!' 1>&2; exit 2
fi

if test ! -f core.info
then echo "The core.info file is not present." 1>&2; exit 3
fi

if test -d /tmp/$DIST-$PKG/
then rm -r /tmp/$DIST-$PKG/
fi

if test -d $PKG-$VERSION/
then rm -r $PKG-$VERSION/
fi
if test -f SHA384.txt
then sha384sum -c SHA384.txt || exit 4
fi
tar xjf $PKG-$VERSION.tar.bz2
cd $PKG-$VERSION || exit 5

CFLAGS="-Os -march=$ARCH" \
./configure \
	--bindir=/usr/bin \
	--build=$TARGET-$DIST-linux-gnu \
	--disable-nls \
	--libdir=/usr/lib \
        --mandir=/usr/man \
	--prefix=/usr \
	--sbindir=/usr/bin

for i in chat ppp{d,dump,stats}
do sed -i "/^COPTS/ s/-O2/-Os -march=$ARCH/" $i/Makefile
done
sed -i "/^COPTS/ s/-O2/-Os -march=$ARCH/" pppd/plugins/Makefile
sed -i "/^CFLAGS/ s/-O2/-Os -march=$ARCH/" pppd/plugins/radius/Makefile
for i in pppoatm rp-pppoe
do sed -i "/^COPTS/ s/-O2/-Os -march=$ARCH/" pppd/plugins/$i/Makefile
done

CC=gcc make all || exit 6
mkdir -p /tmp/$DIST-$PKG/usr/man/man8/
mkdir -p /tmp/$DIST-$PKG/usr/bin/
for i in chat ppp{d,dump,stats}
do install -m 644 -o root -g root $i/$i.8 /tmp/$DIST-$PKG/usr/man/man8/
install -m 750 -o root -g root -s $i/$i /tmp/$DIST-$PKG/usr/bin/
done

find /tmp/$DIST-$PKG/usr/man/ -type f -exec bzip2 -9 {} \;

cd ..
cp core.info /tmp/$DIST-$PKG/
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG/
	echo Before packaging: chown -R root: /tmp/$DIST-$PKG/
else chown -R root: /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
fi
rm -r $PKG-$VERSION/
