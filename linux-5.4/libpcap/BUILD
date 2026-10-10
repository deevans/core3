# CorePKG build script for libpcap.
# Copyright David Egan Evans
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the Free
# Software Foundation; either version 2 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
# more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc., 59
# Temple Place, Suite 330, Boston, MA 02111-1307 USA

ARCH=i486
DIST=deevans
PKG=libpcap
TARGET=i486
VERSION=1.10.4

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

if test -f SHA384.txt
then sha384sum -c SHA384.txt || exit 4
fi
tar xzf $PKG-$VERSION.tar.gz
cd $PKG-$VERSION/ || exit 5

CFLAGS="-Os -march=$ARCH" \
./configure \
	--build=$TARGET-$DIST-linux-gnu \
	--mandir=/usr/man \
	--prefix=/usr
CC=gcc make || exit 7
CC=gcc make install DESTDIR=/tmp/$DIST-$PKG/

bzip2 -9 /tmp/$DIST-$PKG/usr/man/man?/*.?
mkdir -p /tmp/$DIST-$PKG-doc/usr/man/
mv /tmp/$DIST-$PKG/usr/man/man{3,7}/ /tmp/$DIST-$PKG-doc/usr/man/

# Does man-db need this configured?
for i in /tmp/$DIST-$PKG-doc/usr/man/man3/*.3pcap
do
	if ! test -L $i
	then bzip2 -9 $i
	fi
done
unset i

(cd /tmp/$DIST-$PKG-doc/usr/man/man3/
 for i in pcap_datalink_val_to_description pcap_datalink_val_to_description_or_dlt 
 do rm $i.3pcap
	echo .so pcap_datalink_val_to_name.3pcap > $i.3pcap
 done
 unset i

 for i in pcap_fopen_offline pcap_fopen_offline_with_tstamp_precision
 do rm $i.3pcap
	echo .so pcap_open_offline.3pcap > $i.3pcap
 done
 unset i

 for i in pcap_dispatch pcap_dump_fopen pcap_free_datalinks \
	pcap_free_tstamp_types pcap_freealldevs pcap_getnonblock \
	pcap_minor_version pcap_next pcap_perror \
	pcap_open_dead_with_tstamp_precision \
	pcap_open_offline_with_tstamp_precision pcap_sendpacket \
	pcap_tstamp_type_val_to_description
 do rm $i.3pcap
 done
 unset i

 echo .so pcap_loop.3pcap > pcap_dispatch.3pcap
 echo .so pcap_dump_open.3pcap > pcap_dump_fopen.3pcap
 echo .so pcap_list_datalinks.3pcap > pcap_free_datalinks.3pcap
 echo .so pcap_list_tstamp_types.3pcap > pcap_free_tstamp_types.3pcap
 echo .so pcap_findalldevs.3pcap > pcap_freealldevs.3pcap
 echo .so pcap_setnonblock.3pcap > pcap_getnonblock.3pcap
 echo .so pcap_major_version.3pcap > pcap_minor_version.3pcap
 echo .so pcap_next_ex.3pcap > pcap_next.3pcap
 echo .so pcap_geterr.3pcap > pcap_perror.3pcap
 echo .so pcap_open_dead.3pcap > pcap_open_dead_with_tstamp_precision.3pcap
 echo .so pcap_open_offline.3pcap > pcap_open_offline_with_tstamp_precision.3pcap
 echo .so pcap_inject.3pcap > pcap_sendpacket.3pcap
 echo .so pcap_tstamp_type_val_to_name.3pcap > pcap_tstamp_type_val_to_description.3pcap
 bzip2 -9 *.3pcap
)

find /tmp/$DIST-$PKG/ | xargs file | \
	grep -e "executable" -e "shared object" | \
	grep ELF | cut -f1 -d: | xargs strip 2> /dev/null

cd ..
cp core.info /tmp/$DIST-$PKG/
cp core-doc.info /tmp/$DIST-$PKG-doc/core.info
if test $(id -u) -ne 0
then echo $PKG has been installed to /tmp/$DIST-$PKG{,-doc}/
	echo Before packaging, chown -R root: /tmp/$DIST-$PKG{,-doc}/
else chown -R root: /tmp/$DIST-$PKG{,-doc}/
	corepkg -c /tmp/$DIST-$PKG/ && rm -r /tmp/$DIST-$PKG/
	corepkg -c /tmp/$DIST-$PKG-doc/ && rm -r /tmp/$DIST-$PKG-doc/
fi
rm -r $PKG-$VERSION/
