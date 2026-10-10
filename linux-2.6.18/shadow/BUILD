# CorePKG build script for shadow
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
PKG=shadow
VERSION=4.1.4.3
ARCH=i486

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
if test -f SHA1.txt
then sha1sum -c SHA1.txt || exit 4
fi
tar xjf $PKG-$VERSION.tar.bz2
cd $PKG-$VERSION || exit 5

CFLAGS="-Os -march=$ARCH" ./configure \
	--bindir=/usr/bin \
	--build=$ARCH-$DIST-linux-gnu \
	--disable-nls \
	--libdir=/usr/lib \
        --mandir=/usr/man \
	--prefix=/usr \
	--sbindir=/usr/bin \
	--sysconfdir=/etc \
	--without-selinux

make || exit 6
make install-strip DESTDIR=/tmp/$DIST-$PKG/

# Why doesn't this install automatically?
mkdir -p /tmp/$DIST-$PKG/usr/lib/
cp libmisc/libmisc.a /tmp/$DIST-$PKG/usr/lib/
cp lib/.libs/libshadow.a /tmp/$DIST-$PKG/usr/lib/

cp ../group.5 /tmp/$DIST-$PKG/usr/man/man5/

for i in vi{gr,pw}
do rm /tmp/$DIST-$PKG/usr/sbin/$i
	rm /tmp/$DIST-$PKG/usr/man/man8/$i.8
done
for i in groups
do rm /tmp/$DIST-$PKG/usr/bin/$i
	rm /tmp/$DIST-$PKG/usr/man/man1/$i.1
done

rm -r /tmp/$DIST-$PKG/usr/man/man3/
rm -r /tmp/$DIST-$PKG/etc/
#rm /tmp/$DIST-$PKG/usr/lib/*.la

find /tmp/$DIST-$PKG/usr/man/ -type f -exec bzip2 -9 {} \;

#find /tmp/$DIST-$PKG/ | xargs file | \
#	grep -e "executable" -e "shared object" | \
#	grep ELF | cut -f 1 -d : | xargs strip --strip-unneeded

# Because --sbindir= doesn't work?
mv /tmp/$DIST-$PKG/usr/sbin/* /tmp/$DIST-$PKG/usr/bin/
rmdir /tmp/$DIST-$PKG/usr/sbin/
#chmod o-rwx /tmp/$DIST-$PKG/usr/sbin/*

cd ..
cp core.info /tmp/$DIST-$PKG/
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG/
	echo Before packaging: chown -R root: /tmp/$DIST-$PKG/
else chown -R root: /tmp/$DIST-$PKG/ # This wipes out SUID
	chmod u=rwxs,g=x,o=x /tmp/$DIST-$PKG/usr/bin/{ch{age,fn,sh},su}
	chmod u=rwxs,g=x,o=x /tmp/$DIST-$PKG/usr/bin/{expiry,newgrp}
	chmod u=rwxs,g=x,o=x /tmp/$DIST-$PKG/usr/bin/{g,}passwd
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
fi
rm -r $PKG-$VERSION/
