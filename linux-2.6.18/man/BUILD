# CorePKG build script for man.
DIST=deevans
PKG=man
VERSION=1.6g
ARCH=i486

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
if test -f SHA1.txt
then sha1sum -c SHA1.txt || exit 4
fi
tar xzf $PKG-$VERSION.tar.gz
cd $PKG-$VERSION || exit 5

./configure +traditional +lang en -confdir /etc
CC=gcc CFLAGS="-Os -march=$ARCH" make all || exit 6
mkdir -p /tmp/$DIST-$PKG/usr/man/man{1,5,8}/
mkdir -p /tmp/$DIST-$PKG/usr/bin/
for i in man whatis apropos
do cp src/$i /tmp/$DIST-$PKG/usr/bin/
	cp man/en/$i.man /tmp/$DIST-$PKG/usr/man/man1/$i.1
done
cp man2html/man2html /tmp/$DIST-$PKG/usr/bin/
cp man2html/man2html.1 /tmp/$DIST-$PKG/usr/man/man1/
cp man/en/man.conf.man /tmp/$DIST-$PKG/usr/man/man5/man.conf.5

sed -i '/^AWK/ s/^/#/' src/makewhatis
sed -i '/^# AWK/ s/^# //' src/makewhatis
sed -i '/^DEFMANPATH/ cDEFMANPATH=/usr/man' src/makewhatis
sed -i '/^DEFCATPATH/ cDEFCATPATH=' src/makewhatis
sed -i '/^sections/ s/ n l//' src/makewhatis
sed -i '/^for\ name/ s/$/ -w/' src/makewhatis

cp src/makewhatis /tmp/$DIST-$PKG/usr/bin/
cp man/en/makewhatis.8 /tmp/$DIST-$PKG/usr/man/man8/

find /tmp/$DIST-$PKG/usr/man/ -type f -exec bzip2 -9 {} \;

find /tmp/$DIST-$PKG/ | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f 1 -d : | xargs strip --strip-unneeded 2>/dev/null

cd ..
cp core.info /tmp/$DIST-$PKG/
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG/
	echo Before packaging: chown -R root: /tmp/$DIST-$PKG/
else chown -R root: /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
fi
rm -r $PKG-$VERSION/
