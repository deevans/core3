# CorePKG build script for module-init-tools.
# Copyright 2011, 2022 David Egan Evans
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
PKG=module-init-tools
VERSION=3.12

if test ! -w .
then echo 'Cannot write to this directory!' 1>&2; exit 2
fi

if test ! -f core.info
then echo "The core.info file is not present." 1>&2; exit 3
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
tar xjf $PKG-$VERSION.tar.bz2 || exit 4
cd $PKG-$VERSION || exit 5

# Because of a weird rebuild thing in 3.2:
echo '.so modprobe.conf.5' > modprobe.d.5

./configure \
	--prefix=/usr \
	--bindir=/usr/bin \
	--sbindir=/usr/bin \
        --mandir=/usr/man
make || exit 6
make install DESTDIR=/tmp/$DIST-$PKG/

# Because --mandir doesn't (or at least didn't) work:
mv /tmp/$DIST-$PKG/usr/share/man/ /tmp/$DIST-$PKG/usr/
rmdir /tmp/$DIST-$PKG/usr/share/

find /tmp/$DIST-$PKG/usr/man/ -type f -exec gzip -9 {} \;
for i in $(find /tmp/$DIST-$PKG/usr/man/ -type l)
do ln -s $(readlink "$i").gz "$i".gz
	rm "$i"
done

find /tmp/$DIST-$PKG/ | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f1 -d: | xargs strip 2> /dev/null

cd ..
cp core.info /tmp/$DIST-$PKG/
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG/
else chown -R root: /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
fi
rm -r $PKG-$VERSION
