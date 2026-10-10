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
# this program; if not, see <https://www.gnu.org/licenses/>.

DIST=deevans
PKG=e2fsprogs
VERSION=1.41.14
ARCH=pentium3
TARGET=i486

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
if test -f SHA384.txt
then sha384sum -c SHA384.txt || exit 4
fi
tar xzf $PKG-$VERSION.tar.gz
cd $PKG-$VERSION || exit 5

# disable-tls on Linux 2.4 but not 2.6:
CC=gcc CFLAGS="-Os -march=$ARCH" ./configure \
	--bindir=/usr/bin \
	--build=$TARGET-$DIST-linux-gnu \
	--disable-e2initrd_helper \
	--disable-nls \
	--enable-elf-shlibs \
	--infodir=/usr/info \
	--mandir=/usr/man \
	--sbindir=/usr/bin \
	--sysconfdir=/etc \
	--prefix=/usr
make || exit 6
make install DESTDIR=/tmp/$DIST-$PKG/

# util-linux-ng needs libblkid
make install-libs DESTDIR=/tmp/$DIST-$PKG/

cp /tmp/$DIST-$PKG/etc/mke2fs.conf ../mke2fs.conf.$VERSION
rm -r /tmp/$DIST-$PKG/etc/

# Remove linked file names and replace with .so reference files:
for i in mkfs.ext{2,3,4{,dev}}
do rm /tmp/$DIST-$PKG/usr/man/man8/$i.8
#	echo .so man8/mke2fs.8 > /tmp/$DIST-$PKG/usr/man/man8/$i.8
	(cd /tmp/$DIST-$PKG/usr/bin/
		rm $i
#		ln -s mke2fs $i
	)
done
for i in fsck.ext{2,3,4{,dev}}
do rm /tmp/$DIST-$PKG/usr/man/man8/$i.8
	echo .so man8/e2fsck.8 > /tmp/$DIST-$PKG/usr/man/man8/$i.8
	(cd /tmp/$DIST-$PKG/usr/bin/
		rm $i
		ln -s e2fsck $i
	)
done
for i in {find,tune2}fs
do
	(cd /tmp/$DIST-$PKG/usr/bin/
		rm $i
		ln -s e2label $i
	)
done

# Delete ext4 tools for now:
for i in fsck.ext4{,dev}
do rm /tmp/$DIST-$PKG/usr/bin/$i
	rm /tmp/$DIST-$PKG/usr/man/man8/$i.8
done

# Should these from uuid have a .so linked manual?
rm /tmp/$DIST-$PKG/usr/man/man3/uuid_generate{,_{random,time}}.3

find /tmp/$DIST-$PKG/usr/man/ -type f -exec bzip2 -9 {} \;

mkdir -p /tmp/$DIST-$PKG-doc/usr/man/
mv /tmp/$DIST-$PKG/usr/man/man3/ /tmp/$DIST-$PKG-doc/usr/man/

mv /tmp/$DIST-$PKG/usr/{info,share}/ /tmp/$DIST-$PKG-doc/usr/

# Remove pkg-config files for now:
rm -r /tmp/$DIST-$PKG/usr/lib/pkgconfig/

find /tmp/$DIST-$PKG/ | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f 1 -d : | xargs strip --strip-unneeded 2>/dev/null

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
rm -r $PKG-$VERSION/
