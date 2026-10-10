# CorePKG build script for mpc
# Copyright David Egan Evans
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

ARCH=i486
DIST=deevans
PKG=mpc
VERSION=1.2.1

if test ! -w .
then echo 'Cannot write to this directory!' 1>&2; exit 2
fi

if test ! -f core.info
then echo "The core.info file is not present." 1>&2; exit 3
fi
if test ! -f core-doc.info
then echo "The core-doc.info file is not present." 1>&2; exit 4
fi

if test -d /tmp/$DIST-$PKG/
then rm -rf /tmp/$DIST-$PKG/
fi

rm -rf $PKG-$VERSION/
if test -f SHA384.txt
then sha384sum -c SHA384.txt || exit 5
fi
tar xzf $PKG-$VERSION.tar.gz || exit 6
cd $PKG-$VERSION/

CFLAGS="-Os -march=$ARCH" \
./configure \
	--build=$ARCH-$DIST-linux-gnu \
	--infodir=/usr/info \
	--prefix=/usr

make || exit 7
make install DESTDIR=/tmp/$DIST-$PKG/

rm /tmp/$DIST-$PKG/usr/lib/*.la

if test -f /tmp/$DIST-$PKG/usr/info/dir
then rm -f /tmp/$DIST-$PKG/usr/info/dir
fi
bzip2 -9 /tmp/$DIST-$PKG/usr/info/*
mkdir -p /tmp/$DIST-$PKG-doc/usr/
mv /tmp/$DIST-$PKG/usr/info/ /tmp/$DIST-$PKG-doc/usr/

find /tmp/$DIST-$PKG/ | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f1 -d: | xargs strip 2> /dev/null

cd ..
cp core.info /tmp/$DIST-$PKG/
cp core-doc.info /tmp/$DIST-$PKG-doc/core.info
if test $(id -u) -ne 0
then echo "$PKG has been installed to /tmp/$DIST-$PKG/."
	echo 'Before packaging, "chown -R root: /tmp/$DIST-$PKG/".'
else chown -R root: /tmp/$DIST-$PKG/ /tmp/$DIST-$PKG-doc/
	corepkg -c /tmp/$DIST-$PKG/ && rm -rf /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG-doc/ && rm -rf /tmp/$DIST-$PKG-doc/
fi
rm -rf $PKG-$VERSION/
