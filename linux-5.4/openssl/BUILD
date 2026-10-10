# CorePKG build script for OpenSSL.
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
PKG=openssl
VERSION=1.1.1w

if test ! -w .
then echo 'Cannot write to this directory!' 1>&2; exit 2
fi

if test ! -f core.info
then echo "The core.info file is not present." 1>&2; exit 3
fi

if test -d /tmp/$DIST-$PKG/
then rm -rf /tmp/$DIST-$PKG/
fi
if test -d /tmp/$DIST-$PKG-doc/
then rm -rf /tmp/$DIST-$PKG-doc/
fi

rm -rf $PKG-$VERSION/
if test -f SHA256.txt
then sha256sum -c SHA256.txt || exit 4
fi
tar xzf $PKG-$VERSION.tar.gz
cd $PKG-$VERSION/ || exit 5

CFLAGS="-Os -march=$ARCH" ./Configure
CFLAGS="-Os -march=$ARCH" ./config --prefix=/usr --openssldir=/usr/lib shared
# --openssldir=/etc/ssl
# seems like a nice idea, until the openssl.cnf gets overwritten on a
# package upgrade. Users should copy these files to /etc/ssl/, and use 
# the initscript to use that dir instead, if modifications are desired. 
# /usr/lib/ssl/ files should not be modified.

# Should cnf files be in /usr/lib/?
make || exit 6
make test #|| exit 7
#make INSTALL_PREFIX=/tmp/$DIST-$PKG MANDIR=/usr/man install || exit 8
make DESTDIR=/tmp/$DIST-$PKG MANDIR=/usr/man install || exit 8

find /tmp/$DIST-$PKG/ | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f1 -d: | xargs strip 2> /dev/null

mkdir -p /tmp/$DIST-$PKG/usr/share/$PKG/
cp -p LICENSE /tmp/$DIST-$PKG/usr/share/$PKG/LICENSE.txt
bzip2 -9 /tmp/$DIST-$PKG/usr/share/$PKG/LICENSE.txt

mv /tmp/$DIST-$PKG/usr/man/man1/passwd.1 \
	/tmp/$DIST-$PKG/usr/man/man1/ssl_passwd.1
(cd /tmp/$DIST-$PKG/usr/man/
for i in $(find . -type d -name "man?")
do
	(cd $i
	 for j in $(find . -maxdepth 1 -type l)
	 do rm $j
	 done
	 bzip2 -9 *.?
	)
done
)

mkdir -p /tmp/$DIST-$PKG-doc/usr/man/
mv /tmp/$DIST-$PKG/usr/man/man{3,7}/ /tmp/$DIST-$PKG-doc/usr/man/
mv /tmp/$DIST-$PKG/usr/share/ /tmp/$DIST-$PKG-doc/usr/

cd ..
cp core.info /tmp/$DIST-$PKG/
cp core-doc.info /tmp/$DIST-$PKG-doc/core.info
if test $(id -u) -ne 0
then echo "$PKG has been installed to /tmp/$DIST-$PKG*/."
	echo 'Before packaging, "chown -R root: /tmp/$DIST-$PKG*/".'
else chown -R root: /tmp/$DIST-$PKG{,-doc}/
	corepkg -c /tmp/$DIST-$PKG/ && rm -rf /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG-doc/ && rm -rf /tmp/$DIST-$PKG-doc/
fi
rm -rf $PKG-$VERSION/
