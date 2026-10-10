# CorePKG build for perl
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
PKG=perl
VERSION=5.12.5
ARCH=pentium3

if test ! -w .
then echo 'Cannot write to this directory!' 1>&2; exit 2
fi

if test ! -f core.info
then echo "The core.info file is not present." 1>&2; exit 3
fi
if test ! -f core-doc.info
then echo "The core-doc.info file is not present." 1>&2; exit 4
fi

if test -x /usr/bin/perl
then echo It is recommended to uninstall Perl before building Perl
	exit 5
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
then sha384sum -c SHA384.txt || exit 6
fi
tar xjf $PKG-$VERSION.tar.bz2
cd $PKG-$VERSION || exit 7

./Configure \
	-de \
	-Dcc=gcc \
	-Dprefix=/usr \
	-Dinstallprefix=/tmp/$DIST-$PKG/usr \
	-Uinstallusrbinperl \
	-Dinc_version_list='5.12.5' \
	-Darchname=$ARCH-linux \
	-Doptimize="-Os -march=$ARCH"
make || exit 8
make test #|| exit 9
make install #DESTDIR=/tmp/$DIST-$PKG/ || exit 10

# perlthanks is no longer part of 10:
for i in perl{bug,thanks} perl$VERSION
do rm /tmp/$DIST-$PKG/usr/bin/$i
done
rm /tmp/$DIST-$PKG/usr/man/man1/perlbug.1

for i in CHANGE{S,LOG} ChangeLog Changes ReadMe.txt README TODO
do find /tmp/$DIST-$PKG/ -name $i -exec rm {} \;
done
for i in ChangeLog.* Changes.*
do find /tmp/$DIST-$PKG/ -name $i -exec rm {} \;
done
rm /tmp/$DIST-$PKG/usr/lib/perl5/$VERSION/Encode/README.e2x

# Remove links:
for i in pstruct s2p
do rm /tmp/$DIST-$PKG/usr/man/man1/$i.1
done

mkdir -p /tmp/$DIST-$PKG-doc/usr/man/
mv /tmp/$DIST-$PKG/usr/man/man3/ /tmp/$DIST-$PKG-doc/usr/man/
mv /tmp/$DIST-$PKG/usr/man/man1/ /tmp/$DIST-$PKG-doc/usr/man/
mkdir -p /tmp/$DIST-$PKG-doc/usr/lib/perl5/$VERSION/Encode/
mv /tmp/$DIST-$PKG/usr/lib/perl5/$VERSION/*.pod \
	/tmp/$DIST-$PKG-doc/usr/lib/perl5/$VERSION/
mv /tmp/$DIST-$PKG/usr/lib/perl5/$VERSION/Encode/*.pod \
	/tmp/$DIST-$PKG-doc/usr/lib/perl5/$VERSION/Encode/
mv /tmp/$DIST-$PKG/usr/lib/perl5/$VERSION/pod/ \
	/tmp/$DIST-$PKG-doc/usr/lib/perl5/$VERSION/
mkdir -p /tmp/$DIST-$PKG-doc/usr/lib/perl5/$VERSION/Locale/Maketext/
mv /tmp/$DIST-$PKG/usr/lib/perl5/$VERSION/Locale/*.pod \
	/tmp/$DIST-$PKG-doc/usr/lib/perl5/$VERSION/Locale/
mv /tmp/$DIST-$PKG/usr/lib/perl5/$VERSION/Locale/Maketext/*.pod \
	/tmp/$DIST-$PKG-doc/usr/lib/perl5/$VERSION/Locale/Maketext/
mkdir -p /tmp/$DIST-$PKG-doc/usr/lib/perl5/$VERSION/Net/
mv /tmp/$DIST-$PKG/usr/lib/perl5/$VERSION/Net/*.pod \
	/tmp/$DIST-$PKG-doc/usr/lib/perl5/$VERSION/Net/
mkdir -p /tmp/$DIST-$PKG-doc/usr/lib/perl5/$VERSION/Test/
mv /tmp/$DIST-$PKG/usr/lib/perl5/$VERSION/Test/*.pod \
	/tmp/$DIST-$PKG-doc/usr/lib/perl5/$VERSION/Test/
mkdir -p /tmp/$DIST-$PKG-doc/usr/lib/perl5/$VERSION/$ARCH-linux/
mv /tmp/$DIST-$PKG/usr/lib/perl5/$VERSION/$ARCH-linux/*.pod \
	/tmp/$DIST-$PKG-doc/usr/lib/perl5/$VERSION/$ARCH-linux/

# perlcc no longer appears to be a thing
mkdir /tmp/$DIST-$PKG/usr/man/man1/
for i in a2p c2ph config_data corelist cpan* dprofpp enc2xs find2perl
do mv /tmp/$DIST-$PKG-doc/usr/man/man1/$i.1 /tmp/$DIST-$PKG/usr/man/man1/
done
for i in h2ph h2xs instmodsh libnetcfg perl{,doc,ivp} piconv pl2pm psed
do mv /tmp/$DIST-$PKG-doc/usr/man/man1/$i.1 /tmp/$DIST-$PKG/usr/man/man1/
done
for i in pod{checker,select} pod2* prove ptar{,diff} shasum splain xsubpp
do mv /tmp/$DIST-$PKG-doc/usr/man/man1/$i.1 /tmp/$DIST-$PKG/usr/man/man1/
done

# See the above deletion of links:
echo .so man1/c2ph.1 > /tmp/$DIST-$PKG/usr/man/man1/pstruct.1
echo .so man1/psed.1 > /tmp/$DIST-$PKG/usr/man/man1/s2p.1

# Shouldn't cpanp-run-perl be in libexec or with CPANPLUS?
# Should this be in man1/?
echo .so man3/CPANPLUS::Config.3 > \
	/tmp/$DIST-$PKG-doc/usr/man/man3/cpanp-run-perl.3

find /tmp/$DIST-$PKG/usr/man/ -type f -exec bzip2 -9 {} \;
find /tmp/$DIST-$PKG-doc/usr/man/ -type f -exec bzip2 -9 {} \;

# Why did cpan* above not catch this?
mv /tmp/$DIST-$PKG-doc/usr/man/man1/cpanp.1.bz2 /tmp/$DIST-$PKG/usr/man/man1/
mv /tmp/$DIST-$PKG-doc/usr/man/man1/cpan2dist.1.bz2 \
	/tmp/$DIST-$PKG/usr/man/man1/

find /tmp/$DIST-$PKG/ | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f 1 -d : | xargs strip --strip-unneeded 2>/dev/null

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
rm -r $PKG-$VERSION/
