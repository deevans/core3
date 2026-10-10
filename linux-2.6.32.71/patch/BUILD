# CorePKG build script for GNU patch.
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
PKG=patch
VERSION=2.6.1
ARCH=i486

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
tar xjf $PKG-$VERSION.tar.bz2
cd $PKG-$VERSION || exit 5

CFLAGS="-Os -march=$ARCH" ./configure \
	--bindir=/usr/bin \
	--build=$ARCH-$DIST-linux-gnu \
	--disable-nls \
	--host=$ARCH-$DIST-linux-gnu \
        --mandir=/usr/man \
	--prefix=/usr
make all || exit 6
mkdir -m 755 -p /tmp/$DIST-$PKG/usr/bin/
install -m 755 -o root -g root -s src/patch /tmp/$DIST-$PKG/usr/bin/
mkdir -m 755 -p /tmp/$DIST-$PKG/usr/man/man1/
install -m 755 -o root -g root patch.man /tmp/$DIST-$PKG/usr/man/man1/patch.1

bzip2 -9 /tmp/$DIST-$PKG/usr/man/man1/patch.1

cd ..
cp core.info /tmp/$DIST-$PKG/
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG/
	echo Before packaging: chown -R root: /tmp/$DIST-$PKG/
else chown -R root: /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
fi
rm -r $PKG-$VERSION/
