#!/bin/sh
# mktemp package build script.
# Copyright 2013 David Egan Evans
#
# This software is provided 'as-is', without any express or implied
# warranty. In no event will the authors be held liable for any damages
# arising from the use of this software.
#
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely, subject to the following restrictions:
#
# 1. The origin of this software must not be misrepresented; you must
# not claim that you wrote the original software. If you use this
# software in a product, an acknowledgment in the product documentation
# would be appreciated but is not required.
#
# 2. Altered source versions must be plainly marked as such, and must 
# not be misrepresented as being the original software.
#
# 3. This notice may not be removed or altered from any source distribution.

DIST=deevans
PKG=mktemp
VERSION=1.7

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

tar xzf $PKG-$VERSION.tar.gz || exit 4
cd $PKG-$VERSION || exit 5

CFLAGS="-O2 -march=generic -mtune=generic" \
	./configure \
	--prefix=/usr \
        --mandir=/usr/man \
	--build=i686-$DIST-linux-gnu
make || exit 6
make install DESTDIR=/tmp/$DIST-$PKG

find /tmp/$DIST-$PKG/ | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f1 -d: | xargs strip 2> /dev/null

gzip -9 /tmp/$DIST-$PKG/usr/man/man?/*.?
# Avoid collision with coreutils (I may switch to coreutils mktemp in the future):
mv /tmp/$DIST-$PKG/usr/man/man1/mktemp.1.gz /tmp/$DIST-$PKG/usr/man/man1/mktemp17.1.gz

cd ..
cp core.info /tmp/$DIST-$PKG/
chmod -R u+w,go+r-w,a-s /tmp/$DIST-$PKG
find /tmp/$DIST-$PKG -type d -exec chmod ugo+x {} \;
if test $(id -u) -ne 0
then echo "$PKG has been installed to /tmp/$DIST-$PKG/."
	echo 'Before packaging, "chown -R root: /tmp/$DIST-$PKG/".'
else chown -R root: /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
fi
rm -r $PKG-$VERSION/