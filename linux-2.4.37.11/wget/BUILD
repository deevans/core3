# CorePKG build script for wget.
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
# this program; if not, see <https://www.gnu.org/licenses>.

DIST=deevans
PKG=wget
VERSION=1.12
ARCH=i386

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

tar xjf $PKG-$VERSION.tar.bz2 || exit 5
cd $PKG-$VERSION/ || exit 6

CFLAGS="-Os -march=$ARCH" ./configure \
	--prefix=/usr \
	--infodir=/usr/info \
	--mandir=/usr/man \
	--disable-nls \
	$ARCH-$DIST-linux-gnu
make || exit 7
make install DESTDIR=/tmp/$DIST-$PKG/

rm -r /tmp/$DIST-$PKG/usr/etc/
mkdir -pm 755 /tmp/$DIST-$PKG-doc/usr/
rm /tmp/$DIST-$PKG/usr/info/dir
mv /tmp/$DIST-$PKG/usr/info/ /tmp/$DIST-$PKG-doc/usr/
bzip2 -9 /tmp/$DIST-$PKG-doc/usr/info/*
bzip2 -9 /tmp/$DIST-$PKG/usr/man/man?/*.?

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
