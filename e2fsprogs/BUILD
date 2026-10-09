# CorePKG build script for e2fsprogs.
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
# this program; if not, write to the Free Software Foundation, Inc., 59 Temple
# Place, Suite 330, Boston, MA 02111-1307 USA

DIST=deevans
PKG=e2fsprogs
VERSION=1.41.14
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
tar xzf $PKG-$VERSION.tar.gz
cd $PKG-$VERSION || exit 5

# Disable TLS on Linux 2.4:
CC=gcc CFLAGS="-Os -march=$ARCH" ./configure \
	--bindir=/usr/bin \
	--build=$ARCH-$DIST-linux-gnu \
	--disable-nls \
	--disable-tls \
	--disable-uuidd \
	--infodir=/usr/info \
	--mandir=/usr/man \
	--prefix=/usr \
	--sbindir=/usr/bin \
	--sysconfdir=/etc
make || exit 6
make install DESTDIR=/tmp/$DIST-$PKG/
rm -r /tmp/$DIST-$PKG/etc/

# Remove linked file names and replace with .so reference files:
for i in mkfs.ext{2,3,4{,dev}}
do rm /tmp/$DIST-$PKG/usr/man/man8/$i.8
	echo .so man8/mke2fs.8 > /tmp/$DIST-$PKG/usr/man/man8/$i.8
	(cd /tmp/$DIST-$PKG/usr/bin/
		rm $i
		ln -s mke2fs $i
	)
done
for i in fsck.ext{2,3,4}
do rm /tmp/$DIST-$PKG/usr/man/man8/$i.8
	echo .so man8/e2fsck.8 > /tmp/$DIST-$PKG/usr/man/man8/$i.8
	(cd /tmp/$DIST-$PKG/usr/bin/
		rm $i
		ln -s e2fsck $i
	)
done
# With Linux 2.4, remove ext4:
for i in {fsck,mkfs}.ext4{,dev}
do rm /tmp/$DIST-$PKG/usr/man/man8/$i.8
	rm /tmp/$DIST-$PKG/usr/bin/$i
done
for i in {find,tune2}fs
do
	(cd /tmp/$DIST-$PKG/usr/bin/
		rm $i
		ln -s e2label $i
	)
done
find /tmp/$DIST-$PKG/usr/man/ -type f -exec bzip2 -9 {} \;

find /tmp/$DIST-$PKG/ | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f 1 -d : | xargs strip --strip-unneeded 2>/dev/null

mkdir -p /tmp/$DIST-$PKG-doc/usr/
if test -f /tmp/$DIST-$PKG/usr/info/dir
then rm /tmp/$DIST-$PKG/usr/info/dir
fi
mv /tmp/$DIST-$PKG/usr/info/ /tmp/$DIST-$PKG-doc/usr/
for i in /tmp/$DIST-$PKG-doc/usr/info/*.gz
do gzip -d $i
done
bzip2 -9 /tmp/$DIST-$PKG-doc/usr/info/*

cd ..
cp core.info /tmp/$DIST-$PKG/
cp core-doc.info /tmp/$DIST-$PKG-doc/core.info
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG*/
	echo Before packaging: chown -R root: /tmp/$DIST-$PKG*/
else chown -R root: /tmp/$DIST-$PKG*/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG-doc/ && rm -r /tmp/$DIST-$PKG-doc/
fi
rm -fr $PKG-$VERSION/
