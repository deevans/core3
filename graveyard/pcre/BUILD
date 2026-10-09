# CorePKG build script for pcre.
# Copyright 2011-2012, 2015-2016 David Egan Evans
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
PKG=pcre
VERSION=8.45

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

if test -f SHA256.txt
then sha256sum -c SHA256.txt || exit 4
fi
tar xjf $PKG-$VERSION.tar.bz2 || exit 4
cd $PKG-$VERSION || exit 5

./configure \
	--prefix=/usr \
	--bindir=/usr/bin \
	--docdir=/usr/share/$PKG \
	--sbindir=/usr/bin \
        --mandir=/usr/man \
	--build=x86_64-$DIST-linux-gnu
make || exit 6
make install DESTDIR=/tmp/$DIST-$PKG

find /tmp/$DIST-$PKG/usr/man/ -type f -exec gzip -9 {} \;
for i in $(find /tmp/$DIST-$PKG/usr/man/ -type l)
do ln -s $(readlink "$i").gz "$i".gz
	rm "$i"
done

find /tmp/$DIST-$PKG/ | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f1 -d: | xargs strip 2> /dev/null

rm /tmp/$DIST-$PKG/usr/share/$PKG/{COPY*,*.txt,README,ChangeLog,NEWS,AUTHORS}
mkdir -p /tmp/$DIST-$PKG-doc/usr/man/
mv /tmp/$DIST-$PKG/usr/share/ /tmp/$DIST-$PKG-doc/usr/
mv /tmp/$DIST-$PKG/usr/man/man3/ /tmp/$DIST-$PKG-doc/usr/man/
rm /tmp/$DIST-$PKG-doc/usr/share/$PKG/LICENCE
gzip -9 /tmp/$DIST-$PKG-doc/usr/share/$PKG/html/*.txt

cd ..
cp core.info /tmp/$DIST-$PKG/
cp core-doc.info /tmp/$DIST-$PKG-doc/core.info
chmod -R u+w,go+r-w,a-s /tmp/$DIST-$PKG*/
find /tmp/$DIST-$PKG*/ -type d -exec chmod ugo+x {} \;
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG{,-doc}/
	echo Before packaging: chown -R root: /tmp/$DIST-$PKG{,-doc}/
else chown -R root: /tmp/$DIST-$PKG{,-doc}/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG-doc/ && rm -r /tmp/$DIST-$PKG-doc/
fi
rm -r $PKG-$VERSION/
