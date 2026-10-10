# CorePKG build script for net-tools.
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
# this program; if not, write to the Free Software Foundation, Inc., 59 Temple
# Place, Suite 330, Boston, MA 02111-1307 USA

DIST=deevans
PKG=net-tools
VERSION=2.10
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
if test -f SHA384.txt
then sha384sum -c SHA384.txt || exit 4
fi
tar xjf $PKG-$VERSION.tar.bz2

cd $PKG-$VERSION || exit 5
cp ../config.h .

# Because Coredistro has /bin/env:
sed -i '1s:usr/::' configure.sh

sed -i '/^mandir/ s:share/::' man/Makefile

CFLAGS="-Os -g -march=$ARCH" CC=gcc \
	make || exit 6
BINDIR=/usr/bin SBINDIR=/usr/bin \
	make install DESTDIR=/tmp/$DIST-$PKG/ || exit 7

othertools="arp plipconfig rarp slattach"
CC=gcc CFLAGS="-Os -g -march=$ARCH" make $othertools  || exit 8
for i in $othertools
do cp $i /tmp/$DIST-$PKG/usr/bin/
	cp man/en_US/$i.8 /tmp/$DIST-$PKG/usr/man/man8/
done

# Use hostname from sh-utils (needs to remove man pages, including mii-tool):
#rm /tmp/$DIST-$PKG/bin/hostname
#rm /tmp/$DIST-$PKG/bin/{,dns}domainname
#rm /tmp/$DIST-$PKG/bin/{nis,yp}dnsdomainname

#mkdir -p /tmp/$DIST-$PKG/usr/bin/
#
#cp netstat /tmp/$DIST-$PKG/usr/bin/
#cp arp ifconfig nameif plipconfig rarp route slattach /tmp/$DIST-$PKG/usr/bin/
#
#(cd man/en_US/
#mkdir -p /tmp/$DIST-$PKG/usr/man/man{5,8}/
#cp ethers.5 /tmp/$DIST-$PKG/usr/man/man5/
#for i in arp ifconfig nameif netstat plipconfig rarp route slattach
#do cp $i.8 /tmp/$DIST-$PKG/usr/man/man8/
#done
#)

find /tmp/$DIST-$PKG/usr/man/ -type f -exec bzip2 -9 {} \;

find /tmp/$DIST-$PKG/ | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f 1 -d : | xargs strip --strip-unneeded

cd ..
cp core.info /tmp/$DIST-$PKG/
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG/
	echo Before packaging: chown -R root: /tmp/$DIST-$PKG/
else chown -R root: /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
fi
rm -r $PKG-$VERSION/
