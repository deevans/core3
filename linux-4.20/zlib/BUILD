# CorePKG build script for zlib.
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
PKG=zlib
VERSION=1.2.8

if test ! -w .
then echo 'Cannot write to this directory!' 1>&2; exit 2
fi

if test -d /tmp/$DIST-$PKG/
then rm -rf /tmp/$DIST-$PKG/ || exit 3
fi
if test -d /tmp/$DIST-$PKG-doc/
then rm -rf /tmp/$DIST-$PKG-doc/ || exit 4
fi

if test ! -f core.info
then echo "The core.info file is not present." 1>&2; exit 5
fi
if test ! -f core-doc.info
then echo "The core-doc.info file is not present." 1>&2; exit 6
fi

rm -rf $PKG-$VERSION/

if test -f SHA384.txt
then sha384sum -c SHA384.txt || exit 7
fi
xz -dc $PKG-$VERSION.tar.xz | tar xvf -
cd $PKG-$VERSION/ || exit 8

CFLAGS="-Os -march=$ARCH" \
./configure \
	--prefix=/usr
sed -ie 's:share/man:man:g' Makefile # Use /usr/man/.
make check || exit 9
make install DESTDIR=/tmp/$DIST-$PKG/
mkdir /tmp/$DIST-$PKG/lib
mv /tmp/$DIST-$PKG/usr/lib/libz.so* /tmp/$DIST-$PKG/lib/
(cd /tmp/$DIST-$PKG/usr/lib/
 ln -sf ../../lib/libz.so.$VERSION libz.so.1
)

bzip2 -9 /tmp/$DIST-$PKG/usr/man/man3/$PKG.3
mkdir -p /tmp/$DIST-$PKG-doc/usr/man/
mv /tmp/$DIST-$PKG/usr/man/man3/ /tmp/$DIST-$PKG-doc/usr/man/

find /tmp/$DIST-$PKG/ | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f1 -d: | xargs strip 2> /dev/null

cd ..
cp core.info /tmp/$DIST-$PKG/
cp core-doc.info /tmp/$DIST-$PKG-doc/core.info
if test $(id -u) -ne 0
then echo "$PKG has been installed to /tmp/$DIST-$PKG*/"
	echo Before packaging, "chown -R root: /tmp/$DIST-$PKG*/"
else chown -R root: /tmp/$DIST-$PKG*/
        corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
        corepkg -c /tmp/$DIST-$PKG-doc/ && rm -r /tmp/$DIST-$PKG-doc/
fi
rm -rf $PKG-$VERSION/
