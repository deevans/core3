#!/bin/sh
# Copyright 2014 David Egan Evans
#
# This software is provided 'as-is', without any express or implied
# warranty. In no event will the authors be held liable for any damages
# arising from the use of this software.
#
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely, subject to the following restrictions:
#
# 1. The origin of this software must not be misrepresented; you must
# not claim that you wrote the original software. If you use this
# software in a product, an acknowledgment in the product documentation
# would be appreciated but is not required.
#
# 2. Altered source versions must be plainly marked as such, and must 
# not be misrepresented as being the original software.
#
# 3. This notice may not be removed or altered from any source distribution.

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

tar xJf $PKG-$VERSION.tar.xz || exit 7
cd $PKG-$VERSION || exit 8

patch -p 0 < ../sd_is_mq.patch || exit 9
patch -p 0 < ../stdin.patch || exit 10
patch -p 0 < ../sysmacros.patch || exit 11

BLKID_CFLAGS="-I/usr/include/blkid" BLKID_LIBS="-L/usr/lib -lblkid" \
KMOD_CFLAGS="-I/usr/include" KMOD_LIBS="-L/usr/lib -lkmod" \
./configure \
	--prefix=/usr \
	--exec-prefix=/usr \
	--mandir=/usr/man \
	--libdir=/usr/lib \
	--with-rootprefix='' \
	--sysconfdir=/etc \
	--libexecdir=/usr/lib \
	--bindir=/usr/bin \
	--enable-rule_generator \
	--disable-introspection \
	--disable-gudev \
	--disable-keymap \
	--with-usb-ids-path=/usr/share/misc \
	--with-pci-ids-path=/usr/share/misc \
	--with-systemdsystemunitdir=no \
	--build=x86_64-$DIST-linux-gnu

make || exit 12
make install DESTDIR=/tmp/$DIST-$PKG || exit 13
rm /tmp/$DIST-$PKG/etc/udev/udev.conf

# pkgconfig files go in /usr/lib/pkgconfig:
mkdir -p /tmp/$DIST-$PKG/usr/lib/pkgconfig
mv /tmp/$DIST-$PKG/usr/share/pkgconfig/* \
	/tmp/$DIST-$PKG/usr/lib/pkgconfig/
rmdir /tmp/$DIST-$PKG/usr/share/pkgconfig
install -d /tmp/$DIST-$PKG/usr/lib/udev/devices/pts

# Do we want the API docs?
rm -r /tmp/$DIST-$PKG/usr/share/gtk-doc/
rmdir /tmp/$DIST-$PKG/usr/share/doc/$PKG
rmdir /tmp/$DIST-$PKG/usr/share/doc/

find /tmp/$DIST-$PKG/ | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f1 -d: | xargs strip 2> /dev/null

gzip /tmp/$DIST-$PKG/usr/man/man?/*.?

cd ..
mkdir -p /tmp/$DIST-$PKG/usr/lib/udev/devices/{pts,shm}
cp core.info /tmp/$DIST-$PKG/
chmod -R u+w,go+r-w,a-s /tmp/$DIST-$PKG
find /tmp/$DIST-$PKG -type d -exec chmod ugo+x "{}" \;
if test $(id -u) -ne 0; then
	echo "$PKG has been installed to /tmp/$DIST-$PKG/." 1>&2
	echo 'Before packaging, "chown -R root: /tmp/$DIST-$PKG/" and' 1>&2
	echo 'mknod -m 0666 /tmp/$DIST-$PKG/usr/lib/udev/devices/null c 1 3' 1>&2
else
	mknod -m 0666 /tmp/$DIST-$PKG/usr/lib/udev/devices/null c 1 3
        chown -R root: /tmp/$DIST-$PKG/
        corepkg -c /tmp/$DIST-$PKG/
fi
rm -r $PKG-$VERSION/
