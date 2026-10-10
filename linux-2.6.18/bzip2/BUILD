# CorePKG build script for Bzip2.
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
PKG=bzip2
VERSION=1.0.6
ARCH=pentium3

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
if test -f SHA384.txt
then sha384sum -c SHA384.txt || exit 4
fi
tar xjf $PKG-$VERSION.tar.bz2
cd $PKG-$VERSION || exit 5

sed -i "/^CFLAGS/ s/-O2/-Os -march=$ARCH/" Makefile
make || exit 6
make clean
make install PREFIX=/tmp/$DIST-$PKG/usr

# The Bzip2 Makefile links these, but tar seems to treat these as separate
# files. Coredistro, and general distribution convention, is to use symlinks:
for i in bz{e,f}grep
do
	(cd /tmp/$DIST-$PKG/usr/bin/
	 rm $i
	 ln -s bzgrep $i
	)
done
(cd /tmp/$DIST-$PKG/usr/bin/
	rm bzless
	ln -s bzmore bzless
	rm bzcmp
	ln -s bzdiff bzcmp
	rm bzcat bunzip2
	ln -s bzip2 bzcat
	ln -s bzip2 bunzip2
)

echo .so man1/bzip2.1 > /tmp/$DIST-$PKG/usr/man/man1/bzip2recover.1
echo .so man1/bzip2.1 > /tmp/$DIST-$PKG/usr/man/man1/bzcat.1
echo .so man1/bzip2.1 > /tmp/$DIST-$PKG/usr/man/man1/bunzip2.1
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
rm -r $PKG-$VERSION/
