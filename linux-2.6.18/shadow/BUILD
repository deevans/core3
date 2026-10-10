# CorePKG build script for shadow
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
PKG=shadow
VERSION=4.1.4.3
ARCH=pentium3
TARGET=i686

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

CFLAGS="-Os -march=$ARCH" ./configure \
	--bindir=/usr/bin \
	--build=$TARGET-$DIST-linux-gnu \
	--disable-nls \
	--libdir=/usr/lib \
        --mandir=/usr/man \
	--prefix=/usr \
	--sbindir=/usr/bin \
	--sysconfdir=/etc \
	--without-selinux
make || exit 6
# Coredistro had libshadow.a:
make install DESTDIR=/tmp/$DIST-$PKG/

cp ../group.5 /tmp/$DIST-$PKG/usr/man/man5/
#cp man/dpasswd.8 /tmp/$DIST-$PKG/usr/man/man8/

rm -r /tmp/$DIST-$PKG/etc/

# Because --sbindir= isn't supported before version 4.8:
mv /tmp/$DIST-$PKG/usr/sbin/* /tmp/$DIST-$PKG/usr/bin/
rmdir /tmp/$DIST-$PKG/usr/sbin/

for i in vi{gr,pw} groups
do rm /tmp/$DIST-$PKG/usr/bin/$i
done
rm /tmp/$DIST-$PKG/usr/man/man1/groups.1
rm /tmp/$DIST-$PKG/usr/man/man8/vi{gr,pw}.8

rm -r /tmp/$DIST-$PKG/usr/man/man3/
#rm /tmp/$DIST-$PKG/usr/man/man8/adduser.8
#rm /tmp/$DIST-$PKG/usr/lib/*.la

# Because --disable-nls doesn't work:
#for i in cs de fr hu id it ja ko pl pt_BR
#do rm -r /tmp/$DIST-$PKG/usr/man/$i/
#done

find /tmp/$DIST-$PKG/usr/man/ -type f -exec bzip2 -9 {} \;

find /tmp/$DIST-$PKG/ | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f 1 -d : | xargs strip --strip-unneeded

# getty gets confused:
#mkdir -p /tmp/$DIST-$PKG/bin/
#mv /tmp/$DIST-$PKG/usr/bin/login /tmp/$DIST-$PKG/bin/

cd ..
cp core.info /tmp/$DIST-$PKG/
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG/
	echo Before packaging: chown -R root: /tmp/$DIST-$PKG/
	echo set UID for {ch{age,fn,sh},expiry,newgrp,{,g}passwd} su
else chown -R root: /tmp/$DIST-$PKG/ # This whipes out SUID.
	for i in {ch{age,fn,sh},expiry,newgrp,{,g}passwd} su
	do chmod u+s /tmp/$DIST-$PKG/usr/bin/$i
	done
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
fi
rm -r $PKG-$VERSION/
