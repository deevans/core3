# CorePKG build script for util-linux.
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
# this program; if not, see <https://www.gnu.org/licenses/>.

DIST=deevans
PKG=util-linux-ng
VERSION=2.13.1
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

tar xjf $PKG-$VERSION.tar.bz2 || exit 4
cd $PKG-$VERSION/ || exit 5

CC=gcc CFLAGS="-Os -march=$ARCH" \
./configure \
	--enable-rdev \
	--prefix=/usr \
	--sbindir=/usr/bin
make all HAVE_KILL=yes HAVE_WRITE=yes DISABLE_NIS=yes \
	|| exit 7

# This installs much more than desired:
#make install HAVE_KILL=yes HAVE_WRITE=yes DISABLE_NIS=yes \
#	MAN_DIR=/usr/man DESTDIR=/tmp/$DIST-$PKG

mkdir -p /tmp/$DIST-$PKG/usr/bin/
mkdir -p /tmp/$DIST-$PKG/usr/man/man{1,5,8}/

for i in dmesg renice
do mv sys-utils/$i /tmp/$DIST-$PKG/usr/bin/
done
for i in sys-utils/renice.1 misc-utils/setterm.1
do mv $i /tmp/$DIST-$PKG/usr/man/man1/
done
for i in sys-utils/dmesg.1
do mv $i /tmp/$DIST-$PKG/usr/man/man1/
done
mv misc-utils/setterm /tmp/$DIST-$PKG/usr/bin/

for i in fdformat {fsck,mkfs}.minix mkswap
do mv disk-utils/$i /tmp/$DIST-$PKG/usr/bin/
done
for i in {,c}fdisk
do mv fdisk/$i /tmp/$DIST-$PKG/usr/bin/
done
for i in agetty
do mv login-utils/$i /tmp/$DIST-$PKG/usr/bin/
done
for i in {,u}mount losetup swapon
do mv mount/$i /tmp/$DIST-$PKG/usr/bin/
done

# No longer uses rdev with i586 and later:
for i in tunelp rdev
do mv sys-utils/$i /tmp/$DIST-$PKG/usr/bin/
done
for i in sys-utils/{tunelp,rdev}.8 disk-utils/{fdformat,{fsck,mkfs}.minix}.8
do mv $i /tmp/$DIST-$PKG/usr/man/man8/
done

for i in disk-utils/mkswap.8 fdisk/{,c}fdisk.8 hwclock/hwclock.8
do mv $i /tmp/$DIST-$PKG/usr/man/man8/
done
for i in login-utils/agetty.8 mount/{{,u}mount,losetup,swapon}.8
do mv $i /tmp/$DIST-$PKG/usr/man/man8/
done
mv hwclock/hwclock /tmp/$DIST-$PKG/usr/bin/
(cd /tmp/$DIST-$PKG/usr/bin/
	ln -s swapon swapoff
)
echo .so man8/swapon.8 > /tmp/$DIST-$PKG/usr/man/man8/swapoff.8

for i in cal mcookie whereis
do mv misc-utils/$i /tmp/$DIST-$PKG/usr/bin/
done
for i in col{,crt,rm,umn} more
do mv text-utils/$i /tmp/$DIST-$PKG/usr/bin/
done
for i in misc-utils/{cal,mcookie,whereis}.1 text-utils/col{,crt,rm,umn}.1
do cp $i /tmp/$DIST-$PKG/usr/man/man1/
done
cp text-utils/more.1 /tmp/$DIST-$PKG/usr/man/man1/
mv mount/fstab.5 /tmp/$DIST-$PKG/usr/man/man5/

mv getopt/getopt /tmp/$DIST-$PKG/usr/bin/
mv getopt/getopt.1 /tmp/$DIST-$PKG/usr/man/man1/

# Shamelessly stolen from Slackware:
find /tmp/$DIST-$PKG/ | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f 1 -d : | \
	xargs strip --strip-unneeded

bzip2 -9 /tmp/$DIST-$PKG/usr/man/man?/*.?

cd ..
cp core.info /tmp/$DIST-$PKG/
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG/
	echo Before packaging, chown -R root: /tmp/$DIST-$PKG/
else chown -R root: /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
fi
#rm -r $PKG-$VERSION/
