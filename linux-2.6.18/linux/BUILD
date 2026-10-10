# CorePKG build script for linux.
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
PKG=linux
VERSION=2.6.18

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
if test -d build/
then rm -r build/
fi

if ! test -d /usr/src/
then mkdir -m 755 -p /usr/src/
fi

if test -f SHA384.txt
then sha384sum -c SHA384.txt || exit 4
fi

home="$PWD"
cd /usr/src/
if ! test -d $PKG-$VERSION
then tar xjf $home/$PKG-$VERSION.tar.bz2 || exit 5
fi
mkdir $home/build || exit 6
cd $PKG-$VERSION
make mrproper

cp $home/config $home/build/.config || exit 9
make headers_check O=$home/build ARCH=i386 || exit 7
mkdir -p /tmp/$DIST-$PKG/usr
make INSTALL_HDR_PATH=/tmp/$DIST-$PKG/ headers_install || exit 8

make -j 2 O=$home/build || exit 10

mkdir -p /tmp/$DIST-$PKG/boot/$RELEASE/
cp $home/build/System.map /tmp/$DIST-$PKG/boot/$RELEASE/ || exit 11
cp $home/build/bzImage /tmp/$DIST-$PKG/boot/$RELEASE/ || exit 12
cp $home/build/.config /tmp/$DIST-$PKG/boot/$RELEASE/config || exit 13
make mrproper
(cd /tmp/$DIST-$PKG/usr/lib/modules/$VERSION/
 rm build
 ln -s /usr/src/linux-$VERSION build
)

cd $home
cp core.info /tmp/$DIST-$PKG/
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG/
	echo Before packaging: chown -R root: /tmp/$DIST-$PKG/
else chown -R root: /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
fi
rm -r $PKG-$VERSION/
rm -r build
