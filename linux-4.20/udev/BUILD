# CorePKG build script for udev.
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
PKG=udev
VERSION=182

if test ! -w .
then echo 'Cannot write to this directory!' 1>&2
	exit 2
fi

if test ! -f core.info
then echo "The core.info file is not present." 1>&2
	exit 3
fi

if test -d /tmp/$DIST-$PKG/; then
	if test -w /tmp/$DIST-$PKG/
	then rm -r /tmp/$DIST-$PKG/
	else echo cannot delete DESTDIR 1>&2
		exit 4
	fi
fi

if test -d "$PKG-$VERSION"; then
	if test -w "$PKG-$VERSION"
	then rm -r "$PKG-$VERSION" 
	else echo cannot delete build directory 1>&2
		exit 6
	fi
fi

if test -f SHA384.txt
then sha384sum -c SHA384.txt || exit 7
fi
tar xJf $PKG-$VERSION.tar.xz
cd $PKG-$VERSION/ || exit 8

patch -p 0 < ../sd_is_mq.patch || exit 9
patch -p 0 < ../stdin.patch || exit 10
patch -p 0 < ../sysmacros.patch || exit 11

BLKID_CFLAGS="-I/usr/include/blkid" BLKID_LIBS="-L/usr/lib -lblkid" \
KMOD_CFLAGS="-I/usr/include" KMOD_LIBS="-L/usr/lib -lkmod" \
./configure \
	--build=x86_64-$DIST-linux-gnu \
	--bindir=/usr/bin \
	--disable-introspection \
	--disable-gudev \
	--disable-keymap \
	--enable-rule_generator \
	--exec-prefix=/usr \
	--libdir=/usr/lib \
	--mandir=/usr/man \
	--sysconfdir=/etc \
	--libexecdir=/usr/lib \
	--prefix=/usr \
	--with-pci-ids-path=/usr/share/misc \
	--with-rootprefix='' \
	--with-systemdsystemunitdir=no \
	--with-usb-ids-path=/usr/share/misc

make || exit 12
make install DESTDIR=/tmp/$DIST-$PKG/ || exit 13
rm /tmp/$DIST-$PKG/etc/udev/udev.conf

# pkgconfig files go in /usr/lib/pkgconfig:
mkdir -p /tmp/$DIST-$PKG/usr/lib/pkgconfig
mv /tmp/$DIST-$PKG/usr/share/pkgconfig/* \
	/tmp/$DIST-$PKG/usr/lib/pkgconfig/
rmdir /tmp/$DIST-$PKG/usr/share/pkgconfig
install -d /tmp/$DIST-$PKG/usr/lib/udev/devices/pts

rm /tmp/$DIST-$PKG/usr/lib/*.la

# Do we want the API docs?
rm -r /tmp/$DIST-$PKG/usr/share/gtk-doc/
rmdir /tmp/$DIST-$PKG/usr/share/doc/$PKG
rmdir /tmp/$DIST-$PKG/usr/share/doc/

find /tmp/$DIST-$PKG/ | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f1 -d: | xargs strip 2> /dev/null

bzip2 -9 /tmp/$DIST-$PKG/usr/man/man?/*.?

mkdir -p /tmp/$DIST-$PKG-doc/usr/man/
mv /tmp/$DIST-$PKG/usr/man/man7/ /tmp/$DIST-$PKG-doc/usr/man/

cd ..
mkdir -p /tmp/$DIST-$PKG/usr/lib/udev/devices/{pts,shm}
cp core.info /tmp/$DIST-$PKG/
cp core-doc.info /tmp/$DIST-$PKG-doc/core.info
if test $(id -u) -ne 0; then
	echo "$PKG has been installed to /tmp/$DIST-$PKG*/." 1>&2
	echo 'Before packaging, "chown -R root: /tmp/$DIST-$PKG*/" and' 1>&2
	echo 'mknod -m 0666 /tmp/$DIST-$PKG/usr/lib/udev/devices/null c 1 3' 1>&2
else
	mknod -m 0666 /tmp/$DIST-$PKG/usr/lib/udev/devices/null c 1 3
        chown -R root: /tmp/$DIST-$PKG/
        corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
        corepkg -c /tmp/$DIST-$PKG-doc/ && rm -r /tmp/$DIST-$PKG-doc/
fi
rm -r $PKG-$VERSION/
