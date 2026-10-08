# CorePKG build script for sysvinit.
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
PKG=sysvinit
VERSION=2.84
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
tar xzf $PKG-$VERSION.tar.gz

cd $PKG-$VERSION/src || exit 5
sed -i '/^CC/ s/cc/gcc/' Makefile
sed -i "/^CFLAGS/ s/-O2/-Os -march=$ARCH/" Makefile
make || exit 6

mkdir -m 755 -p /tmp/$DIST-$PKG/{s,usr/}bin/
for i in halt init last killall5 mesg runlevel shutdown sulogin utmpdump wall
do cp $i /tmp/$DIST-$PKG/usr/bin/
done
(cd /tmp/$DIST-$PKG/sbin/
 ln -s ../usr/bin/init init
)

(cd /tmp/$DIST-$PKG/usr/bin/
	ln -s killall5 pidof
	ln -s halt poweroff
	ln -s halt reboot
	ln -s last lastb
	ln -s init telinit
)

mkdir -m 755 -p /tmp/$DIST-$PKG/usr/include/
cp initreq.h /tmp/$DIST-$PKG/usr/include/

cd ../man
mkdir -p /tmp/$DIST-$PKG/usr/man/man{1,5,8}
cp *.1 /tmp/$DIST-$PKG/usr/man/man1/
cp ../../utmpdump.1 /tmp/$DIST-$PKG/usr/man/man1/
cp *.5 /tmp/$DIST-$PKG/usr/man/man5/
cp *.8 /tmp/$DIST-$PKG/usr/man/man8/

cd ../

find /tmp/$DIST-$PKG/usr/man/ -type f -exec bzip2 -9 {} \;

#chmod g-w,o-rwx /tmp/$DIST-$PKG/sbin/*

#find /tmp/$DIST-$PKG/ | xargs file | \
#	grep -e "executable" -e "shared object" | \
#	grep ELF | cut -f 1 -d : | xargs strip --strip-unneeded

cd ..
cp core.info /tmp/$DIST-$PKG/
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG/
	echo Before packaging: chown -R root: /tmp/$DIST-$PKG/
else chown -R root: /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
fi
rm -r $PKG-$VERSION/
