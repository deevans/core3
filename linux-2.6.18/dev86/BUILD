# CorePKG build script for bin86.
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
PKG=dev86
VERSION=0.16.21
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

if test -d $PKG/
then rm -fr $PKG/
fi
if test -f SHA384.txt
then sha384sum -c SHA384.txt || exit 4
fi
tar xjf $PKG-$VERSION.tar.bz2
cd $PKG || exit 5

sed -i "/^CFLAGS/ s/-O2/-Os -march=$ARCH/" Makefile
sed -i "/^CFLAGS/ s/-O /-Os -march=$ARCH /" Makefile
sed -i "/^CFLAGS/ s/-O/-Os -march=$ARCH/" Makefile
sed -i "/^CFLAGS/ s/-O2/-Os -march=$ARCH/" makefile.in
sed -i "/^CFLAGS/ s/-O/-Os -march=$ARCH/" bcc/Makefile
sed -i "/^CCFLAGS/ s/-O/-Os -march=$ARCH/" libc/Make.defs
CC=gcc make DIST=/tmp/$DIST-$PKG LOCALPREFIX=/usr \
	BINDIR=/usr/bin LIBDIR=/usr/lib/bcc install || exit 6
CC=gcc make DIST=/tmp/$DIST-$PKG LOCALPREFIX=/usr \
	MANDIR=/usr/man install-man || exit 6

for i in {nm,size}86
do rm /tmp/$DIST-$PKG/usr/bin/$i
done
(cd /tmp/$DIST-$PKG/usr/bin/
	ln -s objdump86 nm86
	ln -s objdump86 size86
)
mv /tmp/$DIST-$PKG/usr/lib/bcc/as86_encap /tmp/$DIST-$PKG/usr/bin/
echo man1/as86.1 > /tmp/$DIST-$PKG/usr/man/man1/as86_encap.1
cp ../*.1 /tmp/$DIST-$PKG/usr/man/man1/

find /tmp/$DIST-$PKG/usr/man/ -type f -exec bzip2 -9 {} \;

find /tmp/$DIST-$PKG/ | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f 1 -d : | xargs strip --strip-unneeded 2>/dev/null

cd ..
cp core.info /tmp/$DIST-$PKG/
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG/
	echo Before packaging: chown -R root: /tmp/$DIST-$PKG/
else chown -R root: /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
fi
rm -fr $PKG/
