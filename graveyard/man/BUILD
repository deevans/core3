#!/bin/sh
# Copyright 2011 David Egan Evans
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
PKG=man
VERSION=1.6g

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

./configure +lang all \
	-confdir /usr/share/misc \
	-compatibility_mode_for_colored_groff \
	--sbindir=/sbin \
	--mandir=/usr/man
CC=gcc make || exit 6
make install PREFIX=/tmp/$DIST-$PKG/

find /tmp/$DIST-$PKG/ | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f1 -d: | xargs strip 2> /dev/null

for i in $(find /tmp/$DIST-$PKG/usr/man/ -type f)
do gzip -9 $i
done

cd ..
cp core.info /tmp/$DIST-$PKG/
chmod -R u+w,go+r-w,a-s /tmp/$DIST-$PKG/
find /tmp/$DIST-$PKG/ -type d -exec chmod ugo+x {} \;
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG/
	echo Before packaging, chown -R root: /tmp/$DIST-$PKG/
else chown -R root: /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
fi
rm -r $PKG-$VERSION/
