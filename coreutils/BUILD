# CorePKG build script for textutils.
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
PKG=coreutils
VERSION=8.13
ARCH=i386

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
then rm -fr $PKG-$VERSION/
fi
if test -f SHA1.txt
then sha1sum -c SHA1.txt || exit 4
fi
tar xzf $PKG-$VERSION.tar.gz
cd $PKG-$VERSION || exit 5

CFLAGS="-Os -march=$ARCH" ./configure \
	--bindir=/usr/bin \
	--disable-nls \
	--enable-install-program=hostname \
	--enable-no-install-program=chcon,kill,link,mktemp,runcon,stat,unlink,uptime \
	--infodir=/usr/info \
	--libdir=/usr/lib \
	--libexecdir=/usr/lib \
        --mandir=/usr/man \
	--prefix=/usr \
	--sbindir=/usr/bin \
	--build=$ARCH-$DIST-linux-gnu \
	--host=$ARCH-$DIST-linux-gnu \
	--target=$ARCH-$DIST-linux-gnu
make || exit 6
make install DESTDIR=/tmp/$DIST-$PKG/

# This was the Coredistro placement:
#mkdir -p /tmp/$DIST-$PKG/bin/
#mv /tmp/$DIST-$PKG/usr/bin/{cat,head,tail} /tmp/$DIST-$PKG/bin/

#mkdir -p /tmp/$DIST-$PKG/usr/bin/
#mv /tmp/$DIST-$PKG/bin/dircolors /tmp/$DIST-$PKG/usr/bin/
#mv /tmp/$DIST-$PKG/bin/install /tmp/$DIST-$PKG/usr/bin/
# ginstall was added by Coredistro:
(cd /tmp/$DIST-$PKG/usr/bin/
 ln -s install ginstall
)
echo .so man1/install.1 > /tmp/$DIST-$PKG/usr/man/man1/ginstall.1

# The tool chain build process requires the /bin/ path (is it symlinked?):
#mkdir /tmp/$DIST-$PKG/bin/
#mv /tmp/$DIST-$PKG/usr/bin/pwd /tmp/$DIST-$PKG/bin/

# Provided by the shadow command:
#rm /tmp/$DIST-$PKG/usr/man/man1/su.1

# What happened to factor (seq now provides its own manual)?
#do cp ../seq.1 /tmp/$DIST-$PKG/usr/man/man1/

# Should [ have a manual?
# mktemp is used instead of the separate package.

find /tmp/$DIST-$PKG/usr/man/ -type f -exec bzip2 -9 {} \;

if test -f /tmp/$DIST-$PKG/usr/info/dir
then rm -f /tmp/$DIST-$PKG/usr/info/dir
fi
mkdir -p /tmp/$DIST-$PKG-doc/usr/
mv /tmp/$DIST-$PKG/usr/info/ /tmp/$DIST-$PKG-doc/usr/
bzip2 -9 /tmp/$DIST-$PKG-doc/usr/info/*

find /tmp/$DIST-$PKG/ | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f1 -d: | xargs strip --strip-unneeded

cd ..
cp core.info /tmp/$DIST-$PKG/
cp core-doc.info /tmp/$DIST-$PKG-doc/core.info
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG{,-doc}/
	echo Before packaging: chown -R root: /tmp/$DIST-$PKG{,-doc}/
else chown -R root: /tmp/$DIST-$PKG{,-doc}/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG-doc/ && rm -r /tmp/$DIST-$PKG-doc/
fi
rm -fr $PKG-$VERSION/
