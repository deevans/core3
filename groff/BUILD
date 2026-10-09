# CorePKG build script for GNU roff.
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
PKG=groff
VERSION=1.18.1
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
then rm -r $PKG-$VERSION/
fi
if test -f SHA1.txt
then sha1sum -c SHA1.txt || exit 4
fi
tar xzf $PKG-$VERSION.tar.gz
cd $PKG-$VERSION || exit 5

sed -i '1c#!/usr/bin/bash' configure
CFLAGS="-Os -march=$ARCH" CXXFLAGS="-Os -march=$ARCH" \
PAGE=letter ./configure \
	--prefix=/usr \
	--infodir=/usr/info \
	--build=$ARCH-$DIST-linux-gnu
make || exit 6

mkdir -p /tmp/$DIST-$PKG/usr/info
make install prefix=/tmp/$DIST-$PKG/usr infodir=/tmp/$DIST-$PKG/usr/info

rm -r /tmp/$DIST-$PKG/usr/share/doc/
rm -r /tmp/$DIST-$PKG/usr/share/groff/site-tmac/

cp ../grohtml /tmp/$DIST-$PKG/usr/bin/
for i in p{re,ost}-grohtml
do echo .so man1/grohtml.1 > /tmp/$DIST-$PKG/usr/man/man1/$i.1
done

find /tmp/$DIST-$PKG/usr/man/ -type f -exec bzip2 -9 {} \;

mkdir -p /tmp/$DIST-$PKG-doc/usr/man/
mv /tmp/$DIST-$PKG/usr/man/man{5,7}/ /tmp/$DIST-$PKG-doc/usr/man/
if test -f /tmp/$DIST-$PKG/usr/info/dir
then rm -f /tmp/$DIST-$PKG/usr/info/dir
fi
mkdir -p /tmp/$DIST-$PKG-doc/usr/
mv /tmp/$DIST-$PKG/usr/info/ /tmp/$DIST-$PKG-doc/usr/
gzip -9 /tmp/$DIST-$PKG-doc/usr/info/*

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
