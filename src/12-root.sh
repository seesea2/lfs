printf " =========================== 12-root.sh =========================== \n"

#6.35. Libtool
printf "\n\n 6.35 Libtool\n"
cd /sources
rm -rf libtool-2.4.6
tar -xf libtool-2.4.6.tar.xz
cd libtool-2.4.6
./configure --prefix=/usr
make
make install
read -n 1 -s -p "press any key to continue"

cd /sources
rm -rf libtool-2.4.6

#6.36. GDBM
printf "\n\n 6.36. GDBM\n"
cd /sources
rm -rf gdbm-1.13
tar -xf gdbm-1.13.tar.gz
cd gdbm-1.13
./configure --prefix=/usr \
            --disable-static \
            --enable-libgdbm-compat
make
make install
read -n 1 -s -p "press any key to continue"
cd /sources
rm -rf gdbm-1.13

#6.37. Gperf
printf "\n\n 6.37. Gperf\n"
cd /sources
rm -rf gperf-3.1
tar -xf gperf-3.1.tar.gz
cd gperf-3.1

./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.1
make
make -j1 check
read -n 1 -s -p "press any key to continue"

make install
read -n 1 -s -p "press any key to continue"

cd /sources
rm -rf gperf-3.1

#6.38. Expat
printf "\n\n 6.38. Expat\n"
cd /sources
rm -rf expat-2.2.3
tar -xjf expat-2.2.3.tar.bz2
cd expat-2.2.3

sed -i 's|usr/bin/env |bin/|' run.sh.in
./configure --prefix=/usr --disable-static
make
make install
read -n 1 -s -p "press any key to continue"

install -v -dm755 /usr/share/doc/expat-2.2.3
install -v -m644 doc/*.{html,png,css} /usr/share/doc/expat-2.2.3
cd /sources
rm -rf expat-2.2.3

#6.39. Inetutils
printf "\n\n 6.39. Inetutils\n"
cd /sources
rm -rf inetutils-1.9.4
tar -xjf inetutils-1.9.4.tar.xz
cd inetutils-1.9.4

./configure --prefix=/usr        \
            --localstatedir=/var \
            --disable-logger     \
            --disable-whois      \
            --disable-rcp        \
            --disable-rexec      \
            --disable-rlogin     \
            --disable-rsh        \
            --disable-servers
make
make install
read -n 1 -s -p "press any key to continue"

mv -v /usr/bin/{hostname,ping,ping6,traceroute} /bin
mv -v /usr/bin/ifconfig /sbin
cd /sources
rm -rf inetutils-1.9.4

#6.40. Perl
printf "\n\n 6.40. Perl\n"
cd /sources
rm -rf perl-5.26.0
tar -xjf perl-5.26.0.tar.xz
cd perl-5.26.0

echo "127.0.0.1 localhost $(hostname)" > /etc/hosts
export BUILD_ZLIB=False
export BUILD_BZIP2=0

sh Configure -des -Dprefix=/usr                 \
                  -Dvendorprefix=/usr           \
                  -Dman1dir=/usr/share/man/man1 \
                  -Dman3dir=/usr/share/man/man3 \
                  -Dpager="/usr/bin/less -isR"  \
                  -Duseshrplib                  \
                  -Dusethreads
make
make install
read -n 1 -s -p "press any key to continue"
unset BUILD_ZLIB BUILD_BZIP2

cd /sources
rm -rf perl-5.26.0

#6.41. XML::Parser
printf "\n\n 6.41. XML::Parser\n"
cd /sources
rm -rf XML-Parser-2.44
tar -xjf XML-Parser-2.44.tar.gz
cd XML-Parser-2.44

perl Makefile.PL
make
make install
read -n 1 -s -p "press any key to continue"

cd /sources
rm -rf XML-Parser-2.44

#6.42. Intltool
printf "\n\n 6.42. Intltool\n"
cd /sources
rm -rf intltool-0.51.0
tar -xf intltool-0.51.0.tar.gz
cd intltool-0.51.0

sed -i 's:\\\${:\\\$\\{:' intltool-update.in
./configure --prefix=/usr
make
make install
install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO
read -n 1 -s -p "press any key to continue"

cd /sources
rm -rf intltool-0.51.0

#6.43. Autoconf
printf "\n\n 6.43. Autoconf\n"
cd /sources
rm -rf autoconf-2.69
tar -xf autoconf-2.69.tar.xz
cd autoconf-2.69

./configure --prefix=/usr
make
make install
read -n 1 -s -p "press any key to continue"

cd /sources
rm -rf autoconf-2.69

#6.44. Automake
printf "\n\n 6.44. Automake\n"
cd /sources
rm -rf automake-1.15.1
tar -xf automake-1.15.1.tar.xz
cd automake-1.15.1

./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.15.1
make
make install
read -n 1 -s -p "press any key to continue"

cd /sources
rm -rf automake-1.15.1

#6.45. Xz
printf "\n\n 6.45. Xz\n"
cd /sources
rm -rf xz-5.2.3
tar -xf xz-5.2.3.tar.xz
cd xz-5.2.3

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xz-5.2.3
make
make install
read -n 1 -s -p "press any key to continue"
mv -v   /usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} /bin
mv -v /usr/lib/liblzma.so.* /lib
ln -svf ../../lib/$(readlink /usr/lib/liblzma.so) /usr/lib/liblzma.so

cd /sources
rm -rf xz-5.2.3

#6.46. Kmod
printf "\n\n 6.46. Kmod\n"
cd /sources
rm -rf kmod-24
tar -xf kmod-24.tar.xz
cd kmod-24

./configure --prefix=/usr          \
            --bindir=/bin          \
            --sysconfdir=/etc      \
            --with-rootlibdir=/lib \
            --with-xz              \
            --with-zlib
make
make install
read -n 1 -s -p "press any key to continue"

for target in depmod insmod lsmod modinfo modprobe rmmod; do
  ln -sfv ../bin/kmod /sbin/$target
done

ln -sfv kmod /bin/lsmod

cd /sources
rm -rf kmod-24

#6.47. Gettext
printf "\n\n 6.47. Gettext\n"
cd /sources
rm -rf gettext-0.19.8.1
tar -xf gettext-0.19.8.1.tar.xz
cd gettext-0.19.8.1

sed -i '/^TESTS =/d' gettext-runtime/tests/Makefile.in &&
sed -i 's/test-lock..EXEEXT.//' gettext-tools/gnulib-tests/Makefile.in
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-0.19.8.1
make
make install
chmod -v 0755 /usr/lib/preloadable_libintl.so
read -n 1 -s -p "press any key to continue"

cd /sources
rm -rf gettext-0.19.8.1

#6.48. Procps-ng
printf "\n\n 6.48. Procps-ng\n"
cd /sources
rm -rf procps-ng-3.3.12
tar -xf procps-ng-3.3.12.tar.xz
cd procps-ng-3.3.12

./configure --prefix=/usr                            \
            --exec-prefix=                           \
            --libdir=/usr/lib                        \
            --docdir=/usr/share/doc/procps-ng-3.3.12 \
            --disable-static                         \
            --disable-kill
make
make install
read -n 1 -s -p "press any key to continue"

mv -v /usr/lib/libprocps.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libprocps.so) /usr/lib/libprocps.so

cd /sources
rm -rf procps-ng-3.3.12

#6.49. E2fsprogs
printf "\n\n 6.49. E2fsprogs\n"
cd /sources
rm -rf e2fsprogs-1.43.5
tar -xf e2fsprogs-1.43.5.tar.gz
cd e2fsprogs-1.43.5

mkdir -v build
cd build
LIBS=-L/tools/lib                    \
CFLAGS=-I/tools/include              \
PKG_CONFIG_PATH=/tools/lib/pkgconfig \
../configure --prefix=/usr           \
             --bindir=/bin           \
             --with-root-prefix=""   \
             --enable-elf-shlibs     \
             --disable-libblkid      \
             --disable-libuuid       \
             --disable-uuidd         \
             --disable-fsck
make
make install
make install-libs
read -n 1 -s -p "press any key to continue"

chmod -v u+w /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a
gunzip -v /usr/share/info/libext2fs.info.gz
install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info

cd /sources
rm -rf e2fsprogs-1.43.5

#6.50. Coreutils
printf "\n\n 6.50. Coreutils\n"
cd /sources
rm -rf coreutils-8.27
tar -xf coreutils-8.27.tar.xz
cd coreutils-8.27

patch -Np1 -i ../coreutils-8.27-i18n-1.patch
sed -i '/test.lock/s/^/#/' gnulib-tests/gnulib.mk
FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr            \
            --enable-no-install-program=kill,uptime
FORCE_UNSAFE_CONFIGURE=1 make
make install
read -n 1 -s -p "press any key to continue"

mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin
mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin
mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin
mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i s/\"1\"/\"8\"/1 /usr/share/man/man8/chroot.8
mv -v /usr/bin/{head,sleep,nice,test,[} /bin

cd /sources
rm -rf coreutils-8.27

#6.51. Diffutils
printf "\n\n 6.51. Diffutils\n"
cd /sources
rm -rf diffutils-3.6
tar -xf diffutils-3.6.tar.xz
cd diffutils-3.6

./configure --prefix=/usr
make
make install
read -n 1 -s -p "press any key to continue"

cd /sources
rm -rf diffutils-3.6

#6.52. Gawk
