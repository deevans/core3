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
ARCH=i386

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
if test -d $PKG-build/
then rm -fr $PKG-build/
fi
if test -f SHA1.txt
then sha1sum -c SHA1.txt || exit 4
fi
tar xjf $PKG-$VERSION.tar.bz2

cd $PKG-$VERSION
<../CVE-2005-4807.patch patch -p0

cd ..
mkdir $PKG-build && cd $PKG-build || exit 5

CC=gcc CFLAGS="-Os -march=$ARCH" ../$PKG-$VERSION/configure \
	--disable-nls \
	--enable-gprof \
	--enable-shared \
	--prefix=/usr \
	$ARCH-$DIST-linux-gnu

make || exit 6
make info || exit 7
make install DESTDIR=/tmp/$DIST-$PKG/

cd ../$PKG-$VERSION/
cp include/libiberty.h /tmp/$DIST-$PKG/usr/include/
cd ..

# Though LFS suggests tooldir=/usr to get rid of this, for compatiblity with
# Devin's Core, let's keep the lib reference files, but link the native cmds.
# Shamelessly stolen from Slackware:
(cd /tmp/$DIST-$PKG/usr/$ARCH-$DIST-linux-gnu/bin/
	for i in *
	do
		if test -r "/usr/bin/$i"
		then rm $i
			ln -fs /usr/bin/$i .
		fi
	done
	unset i
)

for i in windres nlmconv dlltool
do rm /tmp/$DIST-$PKG/usr/man/man1/$i.1
done
find /tmp/$DIST-$PKG/usr/lib/ -name *.la -exec rm {} \;

find /tmp/$DIST-$PKG/usr/man/ -type f -exec bzip2 -9 {} \;

mkdir -p /tmp/$DIST-$PKG-doc/usr/
mv /tmp/$DIST-$PKG/usr/info/ /tmp/$DIST-$PKG-doc/usr/
if test -f /tmp/$DIST-$PKG-doc/usr/info/dir
then rm -f /tmp/$DIST-$PKG-doc/usr/info/dir
fi
bzip2 -9 /tmp/$DIST-$PKG-doc/usr/info/*

# Binaries are smaller in some cases with this than Core:
find /tmp/$DIST-$PKG/ | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f 1 -d : | xargs strip --strip-unneeded 2>/dev/null

cp core.info /tmp/$DIST-$PKG/
cp core-doc.info /tmp/$DIST-$PKG-doc/core.info
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG{,-doc}/
	echo Before packaging: chown -R root: /tmp/$DIST-$PKG{,-doc}/
else chown -R root: /tmp/$DIST-$PKG{,-doc}/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG-doc/ && rm -r /tmp/$DIST-$PKG-doc/
fi
rm -fr $PKG-$VERSION/
rm -fr $PKG-build/
