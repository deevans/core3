# CorePKG build script for fileutils.
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
# this program; if not, see <https://www.gnu.org/licenses>.

DIST=deevans
PKG=fileutils
VERSION=4.1.11
ARCH=i386

if test ! -w .
then echo 'Cannot write to this directory!' 1>&2; exit 2
fi

if test ! -f core.info
then echo "The core.info file is not present." 1>&2; exit 3
fi

if test -d /tmp/$DIST-$PKG/
then rm -fr /tmp/$DIST-$PKG/
fi

if test -d $PKG-$VERSION/
then rm -fr $PKG-$VERSION/
fi
if test -f SHA1.txt
then sha1sum -c SHA1.txt || exit 4
fi
tar xjf $PKG-$VERSION.tar.bz2
cd $PKG-$VERSION || exit 5

CFLAGS="-Os -march=$ARCH" ./configure \
	--prefix=/usr \
	--bindir=/usr/bin \
	--sbindir=/usr/bin \
        --mandir=/usr/man \
	--disable-nls \
	--build=$ARCH-$DIST-linux-gnu
make || exit 6
make install DESTDIR=/tmp/$DIST-$PKG/

# textutils, fileutils, and sh-utils have coreutils.info files, and of
# course coreutils. The newset would be from sh-utils (or coreutils):
rm -r /tmp/$DIST-$PKG/usr/info/

# This was added by Coredistro:
(cd /tmp/$DIST-$PKG/usr/bin/
 ln -s install ginstall
)
echo .so man1/install.1 > /tmp/$DIST-$PKG/usr/man/man1/ginstall.1

for i in {,un}link stat
do rm /tmp/$DIST-$PKG/usr/bin/$i
	rm /tmp/$DIST-$PKG/usr/man/man1/$i.1
done

find /tmp/$DIST-$PKG/usr/man/ -type f -exec bzip2 -9 {} \;

find /tmp/$DIST-$PKG/ | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f 1 -d : | xargs strip --strip-unneeded 2>/dev/null

cd ..
cp core.info /tmp/$DIST-$PKG/
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG/
	echo Before packaging: chown -R root: /tmp/$DIST-$PKG/
else chown -R root: /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
fi
rm -fr $PKG-$VERSION/
