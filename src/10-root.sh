printf " =========================== 10-root.sh =========================== \n"

export LFS=/mnt/lfs

#6.25 Acl
printf "\n\n 6.25 Acl\n"
cd /sources
rm -rf acl-2.2.52.src
tar -xf acl-2.2.52.src.tar.gz
cd acl-2.2.52.src
sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
sed -i "s:| sed.*::g" test/{sbits-restore,cp,misc}.test
sed -i -e "/TABS-1;/a if (x > (TABS-1)) x = (TABS-1);" \
    libacl/__acl_to_any_text.c
./configure --prefix=/usr    \
            --bindir=/bin    \
            --disable-static \
            --libexecdir=/usr/lib
make
make install install-dev install-lib
read -n 1 -s -p "press any key to continue"

chmod -v 755 /usr/lib/libacl.so
mv -v /usr/lib/libacl.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so
cd /sources
rm -rf acl-2.2.52.src

#6.26 Libcap
printf "\n\n 6.26 Libcap\n"
cd /sources
rm -rf libcap-2.25
tar -xf libcap-2.25.tar.xz
cd libcap-2.25
sed -i '/install.*STALIBNAME/d' libcap/Makefile
make
make RAISE_SETFCAP=no lib=lib prefix=/usr install
read -n 1 -s -p "press any key to continue"

chmod -v 755 /usr/lib/libcap.so
mv -v /usr/lib/libcap.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libcap.so) /usr/lib/libcap.so
cd /sources
rm -rf libcap-2.25

#6.27 Sed
printf "\n\n 6.27 Sed\n"
cd /sources
rm -rf sed-4.4
tar -xf sed-4.4.tar.xz
cd sed-4.4
sed -i 's/usr/tools/'                 build-aux/help2man
sed -i 's/testsuite.panic-tests.sh//' Makefile.in
./configure --prefix=/usr --bindir=/bin
make
make html
make check
read -n 1 -s -p "press any key to continue"

make install
install -d -m755           /usr/share/doc/sed-4.4
install -m644 doc/sed.html /usr/share/doc/sed-4.4
read -n 1 -s -p "press any key to continue"

cd /sources
rm -rf sed-4.4

#6.28 Shadow
printf "\n\n 6.28 Shadow\n"
cd /sources
rm -rf shadow-4.5
tar -xf shadow-4.5.tar.xz
cd shadow-4.5
sed -i 's/groups$(EXEEXT) //' src/Makefile.in
find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;
sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
       -e 's@/var/spool/mail@/var/mail@' etc/login.defs
sed -i 's/1000/999/' etc/useradd
./configure --sysconfdir=/etc --with-group-name-max-length=32
make
make install
read -n 1 -s -p "press any key to continue"

mv -v /usr/bin/passwd /bin

pwconv
grpconv
sed -i 's/yes/no/' /etc/default/useradd
passwd root
cd /sources
rm -rf shadow-4.5

#6.29 Psmisc
printf "\n\n 6.29 Psmisc\n"
cd /sources
rm -rf psmisc-23.1
tar -xf psmisc-23.1.tar.xz
cd psmisc-23.1
./configure --prefix=/usr
make
make install
read -n 1 -s -p "press any key to continue"

mv -v /usr/bin/fuser   /bin
mv -v /usr/bin/killall /bin
cd /sources
rm -rf psmisc-23.1

#6.30 Iana-Etc
printf "\n\n 6.30 Iana-Etc\n"
cd /sources
rm -rf iana-etc-2.30
tar -xjf iana-etc-2.30.tar.bz2
cd iana-etc-2.30
make
make install
read -n 1 -s -p "press any key to continue"
cd /sources
rm -rf iana-etc-2.30

#6.31 Bison
printf "\n\n 6.31 Bison\n"
cd /sources
rm -rf bison-3.0.4
tar -xf bison-3.0.4.tar.xz
cd bison-3.0.4
./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.0.4
make
make install
read -n 1 -s -p "press any key to continue"
cd /sources
rm -rf bison-3.0.4

#6.32 Flex
printf "\n\n 6.32 Flex\n"
cd /sources
rm -rf flex-2.6.4
tar -xf flex-2.6.4.tar.gz
cd flex-2.6.4
sed -i "/math.h/a #include <malloc.h>" src/flexdef.h
HELP2MAN=/tools/bin/true \
./configure --prefix=/usr --docdir=/usr/share/doc/flex-2.6.4
make
make install
ln -sv flex /usr/bin/lex
read -n 1 -s -p "press any key to continue"
cd /sources
rm -rf flex-2.6.4

#6.33 Grep
printf "\n\n 6.33 Grep\n"
cd /sources
rm -rf grep-3.1
tar -xf grep-3.1.tar.xz
cd grep-3.1
./configure --prefix=/usr --bindir=/bin
make
make install
read -n 1 -s -p "press any key to continue"
cd /sources
rm -rf grep-3.1

#6.34 Bash

