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
PKG=procps-ng
VERSION=3.3.17
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
if test -f SHA384.txt
then sha384sum -c SHA384.txt || exit 4
fi
tar xJf $PKG-$VERSION.tar.xz
cd procps-$VERSION/ || exit 5

CFLAGS="-Os -march=$ARCH" \
./configure \
	--build=$ARCH-$DIST-linux-gnu \
	--disable-nls \
	--mandir=/usr/man \
	--prefix=/usr \
	--sbindir=/usr/bin \
	--sysconfdir=/etc

sed -i '/^ldconfig/ s:= ldconfig:= /sbin/ldconfig:' Makefile 
CC=gcc make || exit 6
make install DESTDIR=/tmp/$DIST-$PKG/

# Don't include sysctl.conf example as the man page is sufficient:
rm -r /tmp/$DIST-$PKG/usr/share/

# Because --disable-nls doesn't work:
for i in de fr pl pt_BR sv uk
do rm -r /tmp/$DIST-$PKG/usr/man/$i/
done

rm /tmp/$DIST-$PKG/usr/man/man1/procps.1
echo .so man1/ps.1 > /tmp/$DIST-$PKG/usr/man/man1/procps.1

find /tmp/$DIST-$PKG/usr/man/ -type f -exec bzip2 -9 {} \;
mkdir -p /tmp/$DIST-$PKG-doc/usr/man/
mv /tmp/$DIST-$PKG/usr/man/man3/ /tmp/$DIST-$PKG-doc/usr/man/

rm /tmp/$DIST-$PKG/usr/lib/*.la

cd ..
cp core.info /tmp/$DIST-$PKG/
cp core-doc.info /tmp/$DIST-$PKG-doc/core.info
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG*/
	echo Before packaging: chown -R root: /tmp/$DIST-$PKG*/
else chown -R root: /tmp/$DIST-$PKG*/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG-doc/ && rm -r /tmp/$DIST-$PKG-doc/
fi
rm -r procps-$VERSION/
