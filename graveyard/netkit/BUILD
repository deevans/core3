# CorePKG build script for netkit.
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
PKG=netkit
VERSION=0.17
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

if test -d $PKG-ftp-$VERSION/
then rm -r $PKG-ftp-$VERSION/
fi
if test -d $PKG-ping-$VERSION/
then rm -r $PKG-ping-$VERSION/
fi
if test -d $PKG-telnet-$VERSION/
then rm -r $PKG-telnet-$VERSION/
fi
if test -f SHA1.txt
then sha1sum -c SHA1.txt || exit 4
fi

mkdir -p /tmp/$DIST-$PKG/usr/bin/
mkdir -p /tmp/$DIST-$PKG/usr/man/man1/
mkdir -p /tmp/$DIST-$PKG/usr/man/man5/
mkdir -p /tmp/$DIST-$PKG/usr/man/man8/

tar xzf $PKG-base-$VERSION.tar.gz

cd $PKG-base-$VERSION || exit 5
sed -i "137s/-O2/-Os -march=$ARCH/" configure
./configure --prefix=/usr
make || exit 6
cp ping/ping /tmp/$DIST-$PKG/usr/bin/
cp ping/ping.8 /tmp/$DIST-$PKG/usr/man/man8/

cd ../
tar xzf $PKG-ftp-$VERSION.tar.gz
cd $PKG-ftp-$VERSION || exit 7
patch -p0 <../globc.patch
sed -i "116s/-O2/-Os -march=$ARCH/" configure
./configure --prefix=/usr
make || exit 8
cp ftp/ftp /tmp/$DIST-$PKG/usr/bin/
cp ftp/ftp.1 /tmp/$DIST-$PKG/usr/man/man1/
cp ftp/netrc.5 /tmp/$DIST-$PKG/usr/man/man5/

cd ../
tar xzf $PKG-telnet-$VERSION.tar.gz
cd $PKG-telnet-$VERSION || exit 7

sed -i "171s/-O2/-Os -march=$ARCH/" configure
sed -i "205s/-O2/-Os -march=$ARCH/" configure
./configure --prefix=/usr
patch -p0 <../$PKG-telnet-$VERSION.patch
make || exit 8
cp telnet/telnet /tmp/$DIST-$PKG/usr/bin/
cp telnet/telnet.1 /tmp/$DIST-$PKG/usr/man/man1/

find /tmp/$DIST-$PKG/usr/man/ -type f -exec bzip2 -9 {} \;

find /tmp/$DIST-$PKG/ | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f 1 -d : | xargs strip --strip-unneeded

cd ..
cp core.info /tmp/$DIST-$PKG/
find /tmp/$DIST-$PKG/ -type d -exec chmod ugo+x {} \;
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG/
	echo Before packaging: chown -R root: /tmp/$DIST-$PKG/
else chown -R root: /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
fi
rm -r $PKG-base-$VERSION/
rm -r $PKG-ftp-$VERSION/
rm -r $PKG-telnet-$VERSION/
