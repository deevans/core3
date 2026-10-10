# CorePKG build script for binutils.
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
PKG=binutils
VERSION=2.16.1
ARCH=pentium3
TARGET=i686

if test ! -w .
then echo 'Cannot write to this directory!' 1>&2; exit 2
fi

if test ! -f core.info
then echo "The core.info file is not present." 1>&2; exit 3
fi
if test ! -f core-doc.info
then echo "The core-doc.info file is not present." 1>&2; exit 3
fi

if test -d /tmp/$DIST-$PKG/
then rm -r /tmp/$DIST-$PKG/
fi
if test -d /tmp/$DIST-$PKG-doc/
then rm -r /tmp/$DIST-$PKG-doc/
fi

if test -d $PKG-$VERSION/
then rm -fr $PKG-$VERSION/
fi
if test -f SHA384.txt
then sha384sum -c SHA384.txt || exit 4
fi
tar xjf $PKG-$VERSION.tar.bz2
cd $PKG-$VERSION || exit 5

patch -p0 <../*.patch
CC=gcc CFLAGS="-Os -march=$ARCH" \
	./configure \
	--build=$TARGET-$DIST-linux-gnu \
	--disable-nls \
	--enable-shared \
	--enable-gprof \
	--enable-targets=$TARGET-$DIST-linux-gnu \
	--host=$TARGET-$DIST-linux-gnu \
	--libdir=/usr/lib \
	--mandir=/usr/man \
	--prefix=/usr \
	--target=$TARGET-$DIST-linux-gnu

CC=gcc make || exit 6
make info || exit 7
# Post-2.13 installed ldscripts/. It seems harmless to remove them with
# a localized build environment, but toolchains are tricky, and this is 
# one place I'm more cautious about trimming.
make install DESTDIR=/tmp/$DIST-$PKG || exit 8

if ! test -d /tmp/$DIST-$PKG/usr/include/
then mkdir -p /tmp/$DIST-$PKG/usr/include/
fi
cp include/libiberty.h /tmp/$DIST-$PKG/usr/include/

# Remove Windows/Novell specific manuals:
for i in windres nlmconv dlltool
do rm /tmp/$DIST-$PKG/usr/man/man1/$i.1
done

find /tmp/$DIST-$PKG/usr/lib/ -name *.la -exec rm {} \;

mkdir -p /tmp/$DIST-$PKG/usr/info/
cp binutils/doc/binutils.info* /tmp/$DIST-$PKG/usr/info/
cp bfd/doc/bfd.info* /tmp/$DIST-$PKG/usr/info/
cp gas/doc/as.info* /tmp/$DIST-$PKG/usr/info/
cp gprof/gprof.info* /tmp/$DIST-$PKG/usr/info/
cp ld/ld.info* /tmp/$DIST-$PKG/usr/info/

find /tmp/$DIST-$PKG/usr/man/ -type f -exec bzip2 -9 {} \;

if test -f /tmp/$DIST-$PKG/usr/info/dir
then rm -f /tmp/$DIST-$PKG/usr/info/dir
fi
mkdir -p /tmp/$DIST-$PKG-doc/usr/
mv /tmp/$DIST-$PKG/usr/info/ /tmp/$DIST-$PKG-doc/usr/
bzip2 -9 /tmp/$DIST-$PKG-doc/usr/info/*

find /tmp/$DIST-$PKG/ | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f 1 -d : | xargs strip --strip-unneeded 2>/dev/null

cd ..
cp core.info /tmp/$DIST-$PKG/
cp core-doc.info /tmp/$DIST-$PKG-doc/core.info
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG{,-doc}/
	echo Before packaging: chown -R root: /tmp/$DIST-$PKG{,-doc}/
else chown -R root: /tmp/$DIST-$PKG{,-doc}/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG-doc/ && rm -r /tmp/$DIST-$PKG-doc/
fi
rm -r $PKG-$VERSION/
