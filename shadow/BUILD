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
VERSION=4.0.3
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
then rm -r $PKG-$VERSION/
fi
if test -f SHA1.txt
then sha1sum -c SHA1.txt || exit 4
fi
tar xjf $PKG-$VERSION.tar.bz2
cd $PKG-$VERSION || exit 5

CFLAGS="-Os -march=$ARCH" ./configure \
	--prefix=/usr \
	--libdir=/usr/lib \
        --mandir=/usr/man \
	--bindir=/usr/bin \
	--sbindir=/usr/bin \
	--disable-nls \
	--build=$ARCH-$DIST-linux-gnu
make || exit 6
make install DESTDIR=/tmp/$DIST-$PKG/
for i in gshadow group
do cp ../$i.5 /tmp/$DIST-$PKG/usr/man/man5/
done
cp man/dpasswd.8 /tmp/$DIST-$PKG/usr/man/man8/

#mv /tmp/$DIST-$PKG/usr/bin/passwd /tmp/$DIST-$PKG/bin/
#mv /tmp/$DIST-$PKG/bin/sg /tmp/$DIST-$PKG/usr/bin/
for i in vipw groups
do rm /tmp/$DIST-$PKG/usr/bin/$i
done
rm /tmp/$DIST-$PKG/usr/sbin/vipw

rm -r /tmp/$DIST-$PKG/usr/man/man3/
rm /tmp/$DIST-$PKG/usr/man/man8/vi{gr,pw}.8
rm /tmp/$DIST-$PKG/usr/man/man8/adduser.8
rm /tmp/$DIST-$PKG/usr/lib/*.la

# Because --disable-nls doesn't work:
for i in cs de fr hu id it ja ko pl pt_BR
do rm -r /tmp/$DIST-$PKG/usr/man/$i/
done

find /tmp/$DIST-$PKG/usr/man/ -type f -exec bzip2 -9 {} \;

# This does not make the binaries as small as on Coredistro:
find /tmp/$DIST-$PKG/ | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f 1 -d : | xargs strip --strip-unneeded

for i in passwd su
do chmod u+s /tmp/$DIST-$PKG/usr/bin/$i
done

# Because --sbindir= doesn't work?
mv /tmp/$DIST-$PKG/usr/sbin/* /tmp/$DIST-$PKG/usr/bin/
rmdir /tmp/$DIST-$PKG/usr/sbin/
#chmod o-rwx /tmp/$DIST-$PKG/usr/sbin/*

cd ..
cp core.info /tmp/$DIST-$PKG/
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG/
	echo Before packaging: chown -R root: /tmp/$DIST-$PKG/
else chown -R root: /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
fi
rm -r $PKG-$VERSION/
