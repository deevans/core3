# CorePKG build script for Python.
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
PKG=Python
VERSION=3.4.10

if test ! -w .
then echo 'Cannot write to this directory!' 1>&2; exit 2
fi

if test ! -f core.info
then echo "The core.info file is not present." 1>&2; exit 3
fi

# For pip and setuptools, as well as environment, it is best to
# uninstall python:
if test -x /usr/bin/python3
then echo It is expected to uninstall python during building 1>&2
	exit 4
fi

if test -d /tmp/$DIST-$PKG/
then rm -rf /tmp/$DIST-$PKG/
fi

rm -rf $PKG-$VERSION/
if test -f SHA384.txt
then sha384sum -c SHA384.txt || exit 5
fi
tar xzf $PKG-$VERSION.tgz
cd $PKG-$VERSION || exit 6

CFLAGS="-Os -march=$ARCH" \
./configure \
	--build=$ARCH-$DIST-linux-gnu \
	--host=$ARCH-$DIST-linux-gnu \
	--mandir=/usr/man \
	--prefix=/usr \
	--target=$ARCH-$DIST-linux-gnu
make || exit 7
make install DESTDIR=/tmp/$DIST-$PKG

(cd /tmp/$DIST-$PKG/usr/bin/
 ln -s idle3 idle
 ln -s pydoc3 pydoc
 ln -s python3 python
)

rm /tmp/$DIST-$PKG/usr/man/man1/python3.1
echo .so man1/python3.4.1 > /tmp/$DIST-$PKG/usr/man/man1/python.1
echo .so man1/python3.4.1 > /tmp/$DIST-$PKG/usr/man/man1/python3.1
echo .so man1/python3.4.1 > /tmp/$DIST-$PKG/usr/man/man1/python3m.1
echo .so man1/python3.4.1 > /tmp/$DIST-$PKG/usr/man/man1/python3.4m.1
bzip2 -9 /tmp/$DIST-$PKG/usr/man/man1/*.1

find /tmp/$DIST-$PKG | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f1 -d: | xargs strip --strip-unneeded 2> /dev/null

cd ..
cp core.info /tmp/$DIST-$PKG/
if test $(id -u) -ne 0
then echo "$PKG has been installed to /tmp/$DIST-$PKG/."
	echo "Before packaging, chown -R root: /tmp/$DIST-$PKG/".
else chown -R root: /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
fi
rm -rf $PKG-$VERSION/
