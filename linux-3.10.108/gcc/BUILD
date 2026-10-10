# CorePKG build script for GCC.
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
# this program; if not, see <https://www.gnu.org/licenses/>.

DIST=deevans
PKG=gcc
VERSION=5.5.0
ARCH=i486

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
if test -d build/
then rm -fr build/
fi
if test -f SHA384.txt
then sha384sum -c SHA384.txt || exit 4
fi

tar xzf $PKG-$VERSION.tar.gz

# unwind was originally disabled by Coredistro, but is needed by later glibc:
mkdir build
cd build
CFLAGS="-Os -march=$ARCH" \
../$PKG-$VERSION/configure \
	--build=$ARCH-$DIST-linux-gnu \
	--disable-bootstrap \
	--disable-nls \
	--enable-languages=c,c++ \
	--enable-threads=posix \
	--enable-__cxa_atexit \
	--enable-clocale=gnu \
	--host=$ARCH-$DIST-linux-gnu \
	--infodir=/usr/info \
	--libexecdir=/usr/lib \
	--mandir=/usr/man \
	--prefix=/usr \
	--target=$ARCH-$DIST-linux-gnu
make || exit 6
make -k check #|| exit 7
make install DESTDIR=/tmp/$DIST-$PKG/
rm -r /tmp/$DIST-$PKG/usr/man/man7/
# c++filt was removed by Coredistro, but is missing in later GCC versions.
#rm /tmp/$DIST-$PKG/usr/bin/gccbug

# This is provided by binutils:
#rm /tmp/$DIST-$PKG/usr/lib/libiberty.a

find /tmp/$DIST-$PKG/usr/ -name *.la -exec rm {} \;
find /tmp/$DIST-$PKG/ -name README -exec bzip2 -9 {} \;

echo .so man1/gcc.1 > /tmp/$DIST-$PKG/usr/man/man1/c++.1
echo .so man1/gcc.1 > /tmp/$DIST-$PKG/usr/man/man1/$ARCH-$DIST-linux-gnu-gcc.1
echo .so man1/gcc.1 > \
	/tmp/$DIST-$PKG/usr/man/man1/$ARCH-$DIST-linux-gnu-gcc-$VERSION.1
echo .so man1/gcc.1 > /tmp/$DIST-$PKG/usr/man/man1/$ARCH-$DIST-linux-gnu-g++.1
echo .so man1/gcc.1 > /tmp/$DIST-$PKG/usr/man/man1/$ARCH-$DIST-linux-gnu-c++.1
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
rm -r build/
rm -r $PKG-$VERSION/
