# CorePKG build script for linux.
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

ARCH=i486
DIST=deevans
PKG=linux
RELEASE=3.10
VERSION=$RELEASE.108

if test $(id -u) -gt 0
then echo This shell is not owned UID 0 1>&2; exit 2
fi

if test ! -w .
then echo 'Cannot write to this directory!' 1>&2; exit 3
fi

if test ! -f core.info
then echo "The core.info file is not present." 1>&2; exit 4
fi

if test -d /tmp/$DIST-$PKG/
then rm -r /tmp/$DIST-$PKG/
fi
if ! test -d /usr/src
then mkdir -m 755 -p /usr/src/
fi

home="$PWD"
cd /usr/src/ || exit 5
if test -f $home/$PKG-$VERSION.tar.gz
then tar xzf $home/$PKG-$VERSION.tar.gz || exit 6
else tar xzf $home/$PKG-$RELEASE.tar.gz || exit 6
fi
if test -d $home/build/
then rm -r $home/build/ || exit 7
fi
mkdir $home/build/ || exit 7

if test -d $PKG-$VERSION/
then cd $PKG-$VERSION/
else cd $PKG-$RELEASE/
fi
make mrproper

make headers_check O=$home/build ARCH=x86 || exit 8
make headers_install O=$home/build ARCH=x86 \
 INSTALL_HDR_PATH=/tmp/$DIST-$PKG/usr || exit 9
#cp -R include/* /tmp/$DIST-$PKG/usr/include/

(cd /tmp/$DIST-$PKG/usr/include/
 find . \( -name .install -o -name ..install.cmd \) -delete
)

cp $home/config $home/build/.config
make -j 2 O=$home/build || exit 9
#make O=$home/build bzImage || exit 10
#make O=$home/build modules || exit 11
#make O=$home/build INSTALL_MOD_PATH=/tmp/$DIST-$PKG/usr \
#	modules_install || exit 12

mkdir -p /tmp/$DIST-$PKG/boot/$VERSION/
cp $home/build/System.map $home/build/arch/x86/boot/bzImage \
	/tmp/$DIST-$PKG/boot/$VERSION/ || exit 13
cp $home/build/.config /tmp/$DIST-$PKG/boot/$VERSION/config
#cp $home/grub /tmp/$DIST-$PKG/boot/$RELEASE/
#make mrproper
#(cd /tmp/$DIST-$PKG/usr/lib/modules/$VERSION/
# rm build
# ln -s /usr/src/linux-$RELEASE build
#)

cd $home
cp build/.config config
cp core.info /tmp/$DIST-$PKG/
chown -R root: /tmp/$DIST-$PKG/
corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
rm -r $home/build/
if test -d $home/$PKG-$VERSION/
then rm -r $home/$PKG-$VERSION/
elif test -d $home/$PKG-$RELEASE/
then rm -r $home/$PKG-$RELEASE/
fi
