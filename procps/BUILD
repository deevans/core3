# CorePKG build script for procps.
# Copyright 2010-2025 David Egan Evans
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
PKG=procps
VERSION=3.0.4
ARCH=i386

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
if test -f SHA1.txt
then sha1sum -c SHA1.txt || exit 4
fi
tar xzf $PKG-$VERSION.tar.gz
cd $PKG-$VERSION || exit 5

sed -i "/^CFLAGS/ s/-O2/-Os -march=$ARCH/" Makefile
sed -i '/^man1/ s:/share::' Makefile
sed -i '/^man5/ s:/share::' Makefile
sed -i '/^man8/ s:/share::' Makefile
sed -i '/^ldconfig/ s:= ldconfig:= /sbin/ldconfig:' Makefile 
CC=gcc make || exit 6
make install DESTDIR=/tmp/$DIST-$PKG/
mv /tmp/$DIST-$PKG/bin/* /tmp/$DIST-$PKG/usr/bin/
rmdir /tmp/$DIST-$PKG/bin/
mv /tmp/$DIST-$PKG/sbin/* /tmp/$DIST-$PKG/usr/bin/
rmdir /tmp/$DIST-$PKG/sbin/
rm /tmp/$DIST-$PKG/lib/libproc.so

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
