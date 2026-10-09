# CorePKG build script for GNU less.
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
PKG=less
VERSION=418
ARCH=i386

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
tar xzf $PKG-$VERSION.tar.gz
cd $PKG-$VERSION || exit 5

CFLAGS="-Os -march=$ARCH" ./configure \
	--bindir=/usr/bin \
	--build=$ARCH-$DIST-linux-gnu \
	--host=$ARCH-$DIST-linux-gnu \
	--libdir=/usr/lib \
        --mandir=/usr/man \
	--prefix=/usr \
	--target=$ARCH-$DIST-linux-gnu
make || exit 6
#make install DESTDIR=/tmp/$DIST-$PKG/

mkdir -p /tmp/$DIST-$PKG/usr/bin/
cp less /tmp/$DIST-$PKG/usr/bin/

# Remove this once util-linux takes over:
(cd /tmp/$DIST-$PKG/usr/bin/
	ln -s less more
)
mkdir -p /tmp/$DIST-$PKG/usr/man/man1/
echo .so man1/less.1 > /tmp/$DIST-$PKG/usr/man/man1/more.1

cp lessecho lesskey /tmp/$DIST-$PKG/usr/bin/

#mkdir -p /tmp/$DIST-$PKG/usr/man/man1/
cp less.nro /tmp/$DIST-$PKG/usr/man/man1/less.1
cp lesskey.nro /tmp/$DIST-$PKG/usr/man/man1/lesskey.1
cp lessecho.nro /tmp/$DIST-$PKG/usr/man/man1/lessecho.1
#cp ../lessecho.1 /tmp/$DIST-$PKG/usr/man/man1/

find /tmp/$DIST-$PKG/usr/man/ -type f -exec bzip2 -9 {} \;

find /tmp/$DIST-$PKG/ | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f 1 -d : | xargs strip --strip-unneeded

cd ..
cp core.info /tmp/$DIST-$PKG/
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG/
	echo Before packaging: chown -R root: /tmp/$DIST-$PKG/
else chown -R root: /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
fi
rm -r $PKG-$VERSION/
