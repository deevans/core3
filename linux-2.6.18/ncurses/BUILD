
# CorePKG build script for ncurses.
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
PKG=ncurses
VERSION=5.9
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

sed -i '1c#! /usr/bin/bash' configure
# Add ticlib for tack (which was removed in 5.7):
CFLAGS="-Os -march=$ARCH" \
./configure \
	--prefix=/usr \
	--bindir=/usr/bin \
	--libdir=/usr/lib \
        --mandir=/usr/man \
	--sbindir=/usr/bin \
	--with-shared \
	--with-ticlib \
	--without-ada \
	--without-debug \
	--disable-nls \
	--build=$TARGET-$DIST-linux-gnu
make || exit 6
make install DESTDIR=/tmp/$DIST-$PKG/

mkdir -p /tmp/$DIST-$PKG-doc/usr/man/
mv /tmp/$DIST-$PKG/usr/man/man{3,5,7}/ /tmp/$DIST-$PKG-doc/usr/man/

if test -L /tmp/$DIST-$PKG/usr/man/man1/reset.1
then rm /tmp/$DIST-$PKG/usr/man/man1/reset.1
	echo .so man1/tset.1 > /tmp/$DIST-$PKG/usr/man/man1/reset.1
fi

if test -L /tmp/$DIST-$PKG/usr/man/man1/adacurses.1
then rm /tmp/$DIST-$PKG/usr/man/man1/adacurses.1
	echo .so man1/adacurses-config.1 >\
		/tmp/$DIST-$PKG/usr/man/man1/adacurses.1
fi

for i in captoinfo info{cmp,tocap} tic toe
do mv /tmp/$DIST-$PKG/usr/man/man1/$i.1m /tmp/$DIST-$PKG/usr/man/man1/$i.1
done

find /tmp/$DIST-$PKG/usr/man/ -type f -exec bzip2 -9 {} \;
find /tmp/$DIST-$PKG-doc/usr/man/ -type f -exec bzip2 -9 {} \;
# Remove symlinks (is it worth the .so man3/foo.3x entries?):
# find /tmp/$DIST-$PKG-doc/usr/man/ -type l exec rm {} \;
rm /tmp/$DIST-$PKG-doc/usr/man/man3/*.3x

mkdir -p /tmp/$DIST-$PKG-terminfo/usr/share/
mv /tmp/$DIST-$PKG/usr/share/terminfo/ /tmp/$DIST-$PKG-terminfo/usr/share/

mkdir -p /tmp/$DIST-$PKG/usr/share/terminfo/{a,d,l,r,v,x}

mv /tmp/$DIST-$PKG-terminfo/usr/share/terminfo/a/ansi \
	/tmp/$DIST-$PKG/usr/share/terminfo/a/
mv /tmp/$DIST-$PKG-terminfo/usr/share/terminfo/d/dumb \
	/tmp/$DIST-$PKG/usr/share/terminfo/d/
mv /tmp/$DIST-$PKG-terminfo/usr/share/terminfo/l/linux \
	/tmp/$DIST-$PKG/usr/share/terminfo/l/
mv /tmp/$DIST-$PKG-terminfo/usr/share/terminfo/r/rxvt \
	/tmp/$DIST-$PKG/usr/share/terminfo/r/
mv /tmp/$DIST-$PKG-terminfo/usr/share/terminfo/v/vt1{0{0,2},25} \
	/tmp/$DIST-$PKG/usr/share/terminfo/v/
mv /tmp/$DIST-$PKG-terminfo/usr/share/terminfo/v/vt13{1,2} \
	/tmp/$DIST-$PKG/usr/share/terminfo/v/
mv /tmp/$DIST-$PKG-terminfo/usr/share/terminfo/v/vt2{0,2}0 \
	/tmp/$DIST-$PKG/usr/share/terminfo/v/
mv /tmp/$DIST-$PKG-terminfo/usr/share/terminfo/v/vt3{0,2,3,4}0 \
	/tmp/$DIST-$PKG/usr/share/terminfo/v/
mv /tmp/$DIST-$PKG-terminfo/usr/share/terminfo/v/vt4{0,2}0 \
	/tmp/$DIST-$PKG/usr/share/terminfo/v/
mv /tmp/$DIST-$PKG-terminfo/usr/share/terminfo/v/vt5{0,2} \
	/tmp/$DIST-$PKG/usr/share/terminfo/v/
mv /tmp/$DIST-$PKG-terminfo/usr/share/terminfo/v/vt5{10,2{0,5}} \
	/tmp/$DIST-$PKG/usr/share/terminfo/v/
mv /tmp/$DIST-$PKG-terminfo/usr/share/terminfo/v/vt61 \
	/tmp/$DIST-$PKG/usr/share/terminfo/v/
mv /tmp/$DIST-$PKG-terminfo/usr/share/terminfo/x/xterm \
	/tmp/$DIST-$PKG/usr/share/terminfo/x/

chmod a+x /tmp/$DIST-$PKG/usr/lib/*.so.5*

# This is for /lib/ build compatibilty:
#mkdir /tmp/$DIST-$PKG/lib/
#for i in lib{form,menu,ncurses,panel}
#do
#	(cd /tmp/$DIST-$PKG/lib/
#		ln -s ../usr/lib/$i.so.$VERSION $i.so.$VERSION
#		ln -s ../usr/lib/$i.so.$VERSION $i.so.5
#	)
#done

find /tmp/$DIST-$PKG/ | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f 1 -d : | xargs strip --strip-unneeded

cd ..
cp core.info /tmp/$DIST-$PKG/
cp core-doc.info /tmp/$DIST-$PKG-doc/core.info
cp core-terminfo.info /tmp/$DIST-$PKG-terminfo/core.info
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG*/
	echo Before packaging: chown -R root: /tmp/$DIST-$PKG*/
else chown -R root: /tmp/$DIST-$PKG*/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG-doc/ && rm -r /tmp/$DIST-$PKG-doc/
	corepkg -c /tmp/$DIST-$PKG-terminfo/ && rm -r /tmp/$DIST-$PKG-terminfo/
fi
rm -r $PKG-$VERSION/
