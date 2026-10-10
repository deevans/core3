# CorePKG build script for inetutils.
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
PKG=inetutils
VERSION=1.8
ARCH=pentium3
TARGET=i686

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

if test -d $PKG-$VERSION/
then rm -r $PKG-$VERSION/
fi
if test -f SHA384.txt
then sha384sum -c SHA384.txt || exit 4
fi
tar xjf $PKG-$VERSION.tar.bz2
cd $PKG-$VERSION || exit 5

CFLAGS="-Os -march=$ARCH" \
./configure \
	--bindir=/usr/bin \
	--build=$TARGET-$DIST-linux-gnu \
	--disable-ftpd \
	--disable-ifconfig \
	--disable-hostname \
	--disable-inetd \
	--disable-logger \
	--disable-ping6 \
	--disable-rcp \
	--disable-rexec \
	--disable-rexecd \
	--disable-rlogin \
	--disable-rlogind \
	--disable-rsh \
	--disable-rshd \
	--disable-syslogd \
	--disable-talk \
	--disable-talkd \
	--disable-telnetd \
	--disable-tftp \
	--disable-tftpd \
	--disable-traceroute \
	--disable-uucpd \
	--disable-whois \
	--infodir=/usr/info \
	--libdir=/usr/lib \
        --mandir=/usr/man \
	--prefix=/usr \
	--sbindir=/usr/bin
make || exit 6
make install DESTDIR=/tmp/$DIST-$PKG/

# netrc.5 comes from the netkit package:
mkdir -p /tmp/$DIST-$PKG/usr/man/man5/
cp ../netrc.5 /tmp/$DIST-$PKG/usr/man/man5/

find /tmp/$DIST-$PKG/usr/man/ -type f -exec bzip2 -9 {} \;

if test -f /tmp/$DIST-$PKG/usr/info/dir
then rm -f /tmp/$DIST-$PKG/usr/info/dir
fi
mkdir -p /tmp/$DIST-$PKG-doc/usr/
mv /tmp/$DIST-$PKG/usr/info/ /tmp/$DIST-$PKG-doc/usr/
bzip2 -9 /tmp/$DIST-$PKG-doc/usr/info/*

find /tmp/$DIST-$PKG/ | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f 1 -d : | xargs strip --strip-unneeded 2>/dev/null

cd ..
cp core.info /tmp/$DIST-$PKG/
cp core-doc.info /tmp/$DIST-$PKG-doc/core.info
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG{,-doc}/
	echo Before packaging: chown -R root: /tmp/$DIST-$PKG{,-doc}/
else chown -R root: /tmp/$DIST-$PKG{,-doc}/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG-doc/ && rm -r /tmp/$DIST-$PKG-doc/
fi
rm -r $PKG-$VERSION/
