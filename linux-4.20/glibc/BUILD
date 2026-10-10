# CorePKG build script for glibc.
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
PKG=glibc
VERSION=2.28
ARCH=i486

if test ! -w .
then echo 'Cannot write to this directory!' 1>&2; exit 2
fi

if test ! -f core.info
then echo "The core.info file is not present." 1>&2; exit 3
fi
if test ! -f core-doc.info
then echo "The core-doc.info file is not present." 1>&2; exit 3
fi

if test -d /tmp/$DIST-$PKG/
then rm -r /tmp/$DIST-$PKG/
fi
if test -d /tmp/$DIST-$PKG-doc/
then rm -r /tmp/$DIST-$PKG-doc/
fi
if test -d /tmp/$DIST-$PKG-i18n/
then rm -r /tmp/$DIST-$PKG-i18n/
fi

if test -d $PKG-$VERSION/
then rm -fr $PKG-$VERSION/
fi
if test -d $PKG-build/
then rm -fr $PKG-build/
fi
if test -d tz-build/
then rm -fr tz-build/
fi
if test -f SHA384.txt
then sha384sum -c SHA384.txt || exit 4
fi
tar xjf $PKG-$VERSION.tar.bz2
sed -i 's:@BASH@:/bin/bash:' $PKG-$VERSION/elf/ldd.bash.in

mkdir $PKG-build/
cd $PKG-build/

echo "CFLAGS += -march=i486 -fomit-frame-pointer -Os -pipe" > configparms

# stat.h changes in glibc-2.7 make -Os unusable.
# posix_fallocate func issue resolved by omit-frame-pointer:
#CFLAGS="-Os -march=$ARCH -fomit-frame-pointer" \
../$PKG-$VERSION/configure \
	--bindir=/usr/bin \
	--build=$ARCH-$DIST-linux-gnu \
	--disable-profile \
	--disable-nls \
	--disable-werror \
	--enable-add-ons \
	--enable-kernel=3.10 \
	--enable-obsolete-rpc \
	--host=$ARCH-$DIST-linux-gnu \
	--infodir=/usr/info \
	--mandir=/usr/man \
	--prefix=/usr \
	--sbindir=/sbin \
	--target=$ARCH-$DIST-linux-gnu \
	--without-selinux

make || exit 6
#make install install_root=/tmp/$DIST-$PKG/
make install DESTDIR=/tmp/$DIST-$PKG/

# Don't keep rpc or ld cache file:
rm -r /tmp/$DIST-$PKG/etc/

# make localdata/install-locales install_root=/tmp/$DIST-$PKG/i18n/
# Until --disable-nls actually works:
if test -d /tmp/$DIST-$PKG/usr/share/locale/
then rm -r /tmp/$DIST-$PKG/usr/share/locale/
fi

chmod o-rwx /tmp/$DIST-$PKG/sbin/*

# glibcbug was removed in 2.3.4:
rm /tmp/$DIST-$PKG/usr/bin/xtrace

ZONEINFO=/tmp/$DIST-$PKG/usr/share/zoneinfo
mkdir -p $ZONEINFO/{posix,right}
(cd ../glibc-$VERSION/timezone
for tz in etcetera {north,south}america europe africa antarctica \
	{austral,}asia backward pacificnew systemv
do
	zic -L /dev/null -d $ZONEINFO -y "bash yearistype.sh" $tz
	zic -L /dev/null -d $ZONEINFO/posix -y "bash yearistype.sh" $tz
	zic -L leapseconds -d $ZONEINFO/right -y "bash yearistype.sh" $tz
done
)
unset ZONEINFO
cd ../glibc-build/

# For some reason, man pages were not installed since Glibc 2.3:
mkdir -p /tmp/$DIST-$PKG/usr/man/man{1,5,8}/
cp ../manuals/*.1 /tmp/$DIST-$PKG/usr/man/man1/
cp ../manuals/*.5 /tmp/$DIST-$PKG/usr/man/man5/
cp ../manuals/*.8 /tmp/$DIST-$PKG/usr/man/man8/
find /tmp/$DIST-$PKG/usr/man/ -type f -exec bzip2 -9 {} \;

mv /tmp/$DIST-$PKG/usr/sbin/* /tmp/$DIST-$PKG/usr/bin/
rmdir /tmp/$DIST-$PKG/usr/sbin/

if test -f /tmp/$DIST-$PKG/usr/info/dir
then rm -f /tmp/$DIST-$PKG/usr/info/dir
fi
mkdir -p /tmp/$DIST-$PKG-doc/usr/
mv /tmp/$DIST-$PKG/usr/info/ /tmp/$DIST-$PKG-doc/usr/
bzip2 -9 /tmp/$DIST-$PKG-doc/usr/info/*

mkdir -p /tmp/$DIST-$PKG-i18n/usr/{lib,share}/
mv /tmp/$DIST-$PKG/usr/lib/gconv/ /tmp/$DIST-$PKG-i18n/usr/lib/
mv /tmp/$DIST-$PKG/usr/share/i18n/ /tmp/$DIST-$PKG-i18n/usr/share/

#mv /tmp/$DIST-$PKG/etc/zoneinfo/ /tmp/$DIST-$PKG/usr/share/
#mv /tmp/$DIST-$PKG/etc/zoneinfo-leaps/ /tmp/$DIST-$PKG/usr/share/

find /tmp/$DIST-$PKG/ | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f 1 -d : | xargs strip --strip-unneeded 2>/dev/null

cd ..
mkdir -p /tmp/$DIST-$PKG/usr/share/$PKG/
cp $PKG-$VERSION/LICENSES /tmp/$DIST-$PKG/usr/share/$PKG/LICENSES.txt
bzip2 -9 /tmp/$DIST-$PKG/usr/share/$PKG/LICENSES.txt

cp core.info /tmp/$DIST-$PKG/
cp core-doc.info /tmp/$DIST-$PKG-doc/core.info
cp core-i18n.info /tmp/$DIST-$PKG-i18n/core.info
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG{,-doc,-i18n}/
	echo Before packaging: chown -R root: /tmp/$DIST-$PKG{,-doc,-i18n}/
else chown -R root: /tmp/$DIST-$PKG{,-doc,-i18n}/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG-doc/ && rm -r /tmp/$DIST-$PKG-doc/
	corepkg -c /tmp/$DIST-$PKG-i18n/ && rm -r /tmp/$DIST-$PKG-i18n/
fi
rm -fr $PKG-$VERSION/
rm -fr $PKG-build/
rm -fr tz-build/
