#!/bin/sh
# Copyright 2014, 2016-2017, 2024-2025 David Egan Evans
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation; either version 2 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc., 59
# Temple Place, Suite 330, Boston, MA 02111-1307 USA

DIST=deevans
PKG=pkg-config
VERSION=0.29.2
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

sha384sum -c SHA384.txt && tar xjf $PKG-$VERSION.tar.bz2 || exit 3
cd $PKG-$VERSION || exit 4

CFLAGS="-Os -march=$ARCH" ./configure \
	--prefix=/usr \
	--bindir=/usr/bin \
        --mandir=/usr/man \
	--docdir=/usr/share/$PKG \
	--disable-host-tool \
	--with-pc-path=/usr/lib/pkgconfig \
	--with-internal-glib \
	--build=$TARGET-$DIST-linux-gnu
make || exit 5
make check || exit 6
make install DESTDIR=/tmp/$DIST-$PKG

rm -r /tmp/$DIST-$PKG/usr/share/$PKG/

find /tmp/$DIST-$PKG/ | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f1 -d: | xargs strip 2> /dev/null

bzip2 -9 /tmp/$DIST-$PKG/usr/man/man?/*.?

cd ..
cp core.info /tmp/$DIST-$PKG/
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG/
	echo Before packaging, chown -R root: /tmp/$DIST-$PKG/
else chown -R root: /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
fi
rm -r $PKG-$VERSION/
