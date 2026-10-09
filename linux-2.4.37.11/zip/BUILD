# CorePKG build script for Info-Zip zip.
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
PKG=zip
VERSION=30
ARCH=i386

if test ! -w .
then echo 'Cannot write to this directory!' 1>&2
	exit 2
fi

if test ! -f core.info
then echo 'The core.info file is not present.' 1>&2
	exit 3
fi

if test -d /tmp/$DIST-$PKG/
then rm -fr /tmp/$DIST-$PKG/
fi

if test -d $PKG-$VERSION/
then rm -r $PKG-$VERSION/
fi

tar xzf ${PKG}${VERSION}.tgz || exit 4
cd $PKG$VERSION/ || exit 5

sed -i "s/-O3/-Os -march=$ARCH/" unix/configure
sed -i "/^CFLAGS/ s/-O3/-Os -march=$ARCH/" unix/Makefile
mkdir -p /tmp/$DIST-$PKG/
make -f unix/Makefile generic_gcc || exit 7
make -f unix/Makefile install \
	prefix=/tmp/$DIST-$PKG \
	BINDIR=/tmp/$DIST-$PKG/usr/bin \
	MANDIR=/tmp/$DIST-$PKG/usr/man/man1

for i in zip{cloak,note,split}
do echo .so man1/zip.1 > /tmp/$DIST-$PKG/usr/man/man1/$i.1
done
bzip2 -9 /tmp/$DIST-$PKG/usr/man/man?/*.?

strip --strip-unneeded /tmp/$DIST-$PKG/usr/bin/*

cd ..
cp core.info /tmp/$DIST-$PKG/
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG/
	echo Before packaging, chown -R root: /tmp/$DIST-$PKG/
else chown -R root: /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
fi
rm -r $PKG$VERSION/
