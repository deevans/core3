# CorePKG build script for wget.
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
PKG=wget
VERSION=1.13.4
ARCH=pentium3
TARGET=i686

if test ! -w .
then echo 'Cannot write to this directory!' 1>&2
	exit 2
fi

if test ! -f core.info
then echo 'The core.info file is not present.' 1>&2
	exit 3
fi

if test ! -f core-doc.info
then echo 'The core-doc.info file is not present.' 1>&2
	exit 4
fi

if test -d /tmp/$DIST-$PKG/
then rm -r /tmp/$DIST-$PKG/
fi

if test -d /tmp/$DIST-$PKG-doc/
then rm -r /tmp/$DIST-$PKG-doc/
fi

if test -d $PKG-$VERSION/
then rm -r $PKG-$VERSION/
fi

if test -f SHA384.txt
then sha384sum -c SHA384.txt || exit 5
fi
tar xjf $PKG-$VERSION.tar.bz2 || exit 6
cd $PKG-$VERSION/

CFLAGS="-Os -march=$ARCH" ./configure \
	--build=$TARGET-$DIST-linux-gnu \
	--disable-nls \
	--infodir=/usr/info \
	--mandir=/usr/man \
	--prefix=/usr \
	--with-ssl=no
make || exit 7
make install DESTDIR=/tmp/$DIST-$PKG/
bzip2 -9 /tmp/$DIST-$PKG/usr/man/man?/*.?

rm -r /tmp/$DIST-$PKG/usr/etc/
mkdir -pm 755 /tmp/$DIST-$PKG-doc/usr/
mv /tmp/$DIST-$PKG/usr/info/ /tmp/$DIST-$PKG-doc/usr/
if test -f /tmp/$DIST-$PKG-doc/usr/info/dir
then rm /tmp/$DIST-$PKG-doc/usr/info/dir
fi
bzip2 -9 /tmp/$DIST-$PKG-doc/usr/info/*

strip --strip-unneeded /tmp/$DIST-$PKG/usr/bin/*

cd ..
cp core.info /tmp/$DIST-$PKG/
cp core-doc.info /tmp/$DIST-$PKG-doc/core.info
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG*/
	echo Before packaging, chown -R root: /tmp/$DIST-$PKG*/
else chown -R root: /tmp/$DIST-$PKG*/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG-doc/ && rm -r /tmp/$DIST-$PKG-doc/
fi
rm -r $PKG-$VERSION/
