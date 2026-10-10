# CorePKG build script for GCC.
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
PKG=gcc
VERSION=4.0.4
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
# GCC 4.0.x --disable-libiberty: libiberty.a comes from binutils:
#sed -i 's/install_to_$(INSTALL_DEST) //' libiberty/Makefile.in

# GCC 4.0.x --disable-boostrap:
#sed -i 's/^XCFLAGS -$/& -fomit-frame-pointer/' gcc/Makefile.in

# GCC 4.0.x suppress fixincludes:
#sed -i 's@\./fixinc\.sh@-c true@' gcc/Makefile.in

# GCC 4.0.x suppress mktemp test:
sed -i 's/@have_mktemp_command@/yes/' gcc/gccbug.in
cd ../

# unwind was originally disabled by Coredistro, but is needed by later glibc:
mkdir build
cd build
CFLAGS="-march=$ARCH" \
../$PKG-$VERSION/configure \
	--prefix=/usr \
	--enable-languages=c,c++ \
	--enable-threads=posix \
	--enable-__cxa_atexit \
	--enable-clocale=gnu \
	--disable-bootstrap \
	--disable-libiberty \
	--disable-nls \
	--build=$TARGET-$DIST-linux-gnu \
	--host=$TARGET-$DIST-linux-gnu \
	--target=$TARGET-$DIST-linux-gnu
make || exit 6
make -k check #|| exit 7
#make install prefix=/tmp/$DIST-$PKG/usr
make install DESTDIR=/tmp/$DIST-$PKG/
rm -r /tmp/$DIST-$PKG/usr/man/man7/
# c++filt was removed by Coredistro, but is missing in later GCC versions.
rm /tmp/$DIST-$PKG/usr/bin/gccbug

# This is provided by binutils:
rm /tmp/$DIST-$PKG/usr/lib/libiberty.a

find /tmp/$DIST-$PKG/usr/ -name *.la -exec rm {} \;

echo .so man1/gcc.1 > /tmp/$DIST-$PKG/usr/man/man1/c++.1
echo .so man1/gcc.1 > /tmp/$DIST-$PKG/usr/man/man1/$TARGET-$DIST-linux-gnu-gcc.1
echo .so man1/gcc.1 > /tmp/$DIST-$PKG/usr/man/man1/$TARGET-$DIST-linux-gnu-g++.1
echo .so man1/gcc.1 > /tmp/$DIST-$PKG/usr/man/man1/$TARGET-$DIST-linux-gnu-c++.1
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
