# CorePKG build script for kmod.
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
PKG=kmod
VERSION=22

if test ! -w .
then echo 'Cannot write to this directory!' 1>&2; exit 1
fi

if test ! -f core.info
then echo "The core.info file is not present." 1>&2; exit 2
fi

if test -d /tmp/$DIST-$PKG//
then rm -rf /tmp/$DIST-$PKG/
fi

if test -f SHA256.txt
then sha256sum -c SHA256.txt || exit 3
fi
tar xJf $PKG-$VERSION.tar.xz
cd $PKG-$VERSION/ || exit 4
#zlib_CFLAGS="-I/usr/include" zlib_LIBS="-L/lib -lz" \
#liblzma_CFLAGS="-I/usr/include" liblzma_LIBS="-L/lib -llzma" \

CFLAGS="-Os -march=$ARCH" \
./configure \
	--build=$ARCH-$DIST-linux-gnu \
	--bindir=/usr/bin \
	--datadir=/usr/share \
	--disable-test-modules \
	--includedir=/usr/include \
	--libdir=/usr/lib \
	--mandir=/usr/man \
	--prefix=/ \
	--sbindir=/usr/bin \
	--sysconfdir=/etc \
	--with-xz

make || exit 5
make check #|| exit 6
mkdir /tmp/$DIST-$PKG/usr/bin/
make install DESTDIR=/tmp/$DIST-$PKG/

find /tmp/$DIST-$PKG/ | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f1 -d: | xargs strip 2> /dev/null

for i in depmod insmod lsmod modinfo modprobe rmmod
do (cd /tmp/$DIST-$PKG/usr/bin; ln -s kmod $i)
done

bzip2 -9 /tmp/$DIST-$PKG/usr/man/man?/*.?

rm /tmp/$DIST-$PKG/usr/lib/*.la

cd ..
cp core.info /tmp/$DIST-$PKG/
chmod -R u+w,go+r-w,a-s /tmp/$DIST-$PKG/
find /tmp/$DIST-$PKG -type d -exec chmod ugo+x "{}" \;
if test $(id -u) -ne 0
then echo "$PKG has been installed to /tmp/$DIST-$PKG/."
	echo "Before packaging, 'chown -R root: /tmp/$DIST-$PKG/'."
else chown -R root: /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG/ && rm -rf /tmp/$DIST-$PKG/
fi
rm -rf $PKG-$VERSION
