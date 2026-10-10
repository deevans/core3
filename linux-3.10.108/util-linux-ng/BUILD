# CorePKG build script for util-linux.
# Copyright David Egan Evans
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
# this program; if not, see <https://www.gnu.org/licenses/>.

DIST=deevans
PKG=util-linux
VERSION=2.28.2
ARCH=i486

if test ! -w .
then echo 'Cannot write to this directory!' 1>&2
	exit 2
fi

if test ! -f core.info
then echo 'The core.info file is not present.' 1>&2
	exit 3
fi

if test -d /tmp/$DIST-$PKG/
then rm -r /tmp/$DIST-$PKG/
fi

if test -d $PKG-$VERSION/
then rm -r $PKG-$VERSION/
fi

tar xzf $PKG-$VERSION.tar.gz || exit 4
cd $PKG-$VERSION/ || exit 5

CC=gcc CFLAGS="-Os -march=$ARCH" \
./configure \
	--bindir=/usr/bin \
	--disable-bfs \
	--disable-chfn-chsh \
	--disable-ipcrm \
	--disable-ipcs \
	--disable-kill \
	--disable-last \
	--disable-logger \
	--disable-login \
	--disable-mesg \
	--disable-nologin \
	--disable-nls \
	--disable-pg \
	--disable-pivot-root \
	--disable-pylibmount \
	--disable-raw \
	--disable-rename \
	--disable-runuser \
	--disable-setpriv \
	--disable-su \
	--disable-sulogin \
	--disable-ul \
	--disable-utmpdump \
	--disable-wall \
	--infodir=/usr/info \
	--libdir=/usr/lib \
	--mandir=/usr/man \
	--prefix=/usr \
	--without-systemd \
	--without-systemdsystemunitdir

make -j 3 || exit 7

# This installs much more than desired:
make install sbindir=/usr/bin usrsbin_execdir=/usr/bin \
	DESTDIR=/tmp/$DIST-$PKG

# These were not part of Core (or are related, e.g. ipcmk):
for i in flock hexdump ipcmk look lsipc namei rev setsid
do rm /tmp/$DIST-$PKG/usr/bin/$i
	rm /tmp/$DIST-$PKG/usr/man/man1/$i.1
done
for i in blockdev ctrlaltdel isosize mkfs sfdisk
do rm /tmp/$DIST-$PKG/usr/bin/$i
	rm /tmp/$DIST-$PKG/usr/man/man8/$i.8
done

# Remove getops files:
rm -r /tmp/$DIST-$PKG/usr/share/

# Shamelessly stolen from Slackware:
find /tmp/$DIST-$PKG/ | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f 1 -d : | \
	xargs strip --strip-unneeded

for i in i386 linux{32,64}
do echo .so man8/setarch.8 > /tmp/$DIST-$PKG/usr/man/man8/$i.8
done
bzip2 -9 /tmp/$DIST-$PKG/usr/man/man?/*.?

mkdir -p /tmp/$DIST-$PKG-doc/usr/man/
mv /tmp/$DIST-$PKG/usr/man/man3/ /tmp/$DIST-$PKG-doc/usr/man/

# For the IPC info manual:
#mv /tmp/$DIST-$PKG/usr/info/ /tmp/$DIST-$PKG-doc/usr/
#rm /tmp/$DIST-$PKG-doc/usr/info/dir
#bzip2 -9 /tmp/$DIST-$PKG-doc/usr/info/*.info

rm /tmp/$DIST-$PKG/usr/lib/*.la

cd ..
cp core.info /tmp/$DIST-$PKG/
cp core-doc.info /tmp/$DIST-$PKG-doc/core.info
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG*/
	echo Before packaging, chown -R root: /tmp/$DIST-$PKG*/
else chown -R root: /tmp/$DIST-$PKG*/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG-doc/ && rm -r /tmp/$DIST-$PKG-doc/
fi
rm -r $PKG-$VERSION/
