# CorePKG build script for LILO.
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
PKG=lilo
VERSION=22.5.9
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
then rm -fr $PKG-$VERSION/
fi
if test -f SHA1.txt
then sha1sum -c SHA1.txt || exit 4
fi
tar xzf $PKG-${VERSION}.tar.gz
cd $PKG-$VERSION || exit 5

mkdir -p /tmp/$DIST-$PKG/usr/bin/
make install ROOT=/tmp/$DIST-$PKG \
	CC=gcc OPT="-Os -march=$ARCH" MAN_DIR=/usr/man \
	SBIN_DIR=/usr/bin/ USRSBIN_DIR=/usr/bin/ || exit 6
mv /tmp/$DIST-$PKG/usr/bin/keytab-lilo.pl /tmp/$DIST-$PKG/usr/bin/keytab-lilo
cp ../keytab-lilo.8 /tmp/$DIST-$PKG/usr/man/man8/

find /tmp/$DIST-$PKG/usr/man/ -type f -exec bzip2 -9 {} \;

cd ..
cp core.info /tmp/$DIST-$PKG/
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG/
	echo Before packaging: chown -R root: /tmp/$DIST-$PKG/
else chown -R root: /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
fi
rm -fr $PKG-$VERSION/
