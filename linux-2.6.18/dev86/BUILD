# CorePKG build script for bin86.
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
PKG=dev86
VERSION=0.16.21
ARCH=pentium3

if test ! -w .
then echo 'Cannot write to this directory!' 1>&2; exit 2
fi

if test ! -f core.info
then echo "The core.info file is not present." 1>&2; exit 3
fi

if test -d /tmp/$DIST-$PKG/
then rm -fr /tmp/$DIST-$PKG/
fi

if test -d $PKG-$VERSION/
then rm -r $PKG-$VERSION/
fi
if test -f SHA384.txt
then sha384sum -c SHA384.txt || exit 4
fi
tar xjf dev86-$VERSION.tar.bz2
cd $PKG || exit 5

sed -i "/CFLAGS/ s/-O/-Os -march=$ARCH/" Makefile
sed -i "/CFLAGS/ s/-O2/-Os -march=$ARCH/" makefile.in
CC=gcc make DIST=/tmp/$DIST-$PKG LOCALPREFIX=/usr \
	MANDIR=/usr/man BINDIR=/usr/bin # LIBDIR=/usr/lib/bcc \
	# install install-man || exit 6

mkdir -p /tmp/$DIST-$PKG/usr/bin/
for i in as86{,_encap} 
do cp as/$i /tmp/$DIST-$PKG/usr/bin/
done
mkdir -p /tmp/$DIST-$PKG/usr/man/man1/
cp man/*.1 /tmp/$DIST-$PKG/usr/man/man1/
echo .so man1/as86.1 > /tmp/$DIST-$PKG/usr/man/man1/as86_encap.1
for i in {ld,objdump}86
do cp ld/$i /tmp/$DIST-$PKG/usr/bin/
done

# See install{,-man} above if bcc and elks are installed:
for i in bcc elks{,emu}
do rm /tmp/$DIST-$PKG/usr/man/man1/$i.1
done

# Supplementary manuals from Coredistro:
cp ../*.1 /tmp/$DIST-$PKG/usr/man/man1/

# Use symlinks instead:
(cd /tmp/$DIST-$PKG/usr/bin/
	ln -s objdump nm86
	ln -s objdump size86
)

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
