printf " =========================== 9-root.sh =========================== \n"

export LFS=/mnt/lfs

cd /sources

#6.10. Adjusting the Toolchain
printf "\n\n 6.10 Adjusting the Toolchain\n"
mv -v /tools/bin/{ld,ld-old}
mv -v /tools/$(uname -m)-pc-linux-gnu/bin/{ld,ld-old}
mv -v /tools/bin/{ld-new,ld}
ln -sv /tools/bin/ld /tools/$(uname -m)-pc-linux-gnu/bin/ld

gcc -dumpspecs | sed -e 's@/tools@@g'                   \
    -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
    -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' >      \
    `dirname $(gcc --print-libgcc-file-name)`/specs

echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
read -n 1 -s -p "press any key to continue"

grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
read -n 1 -s -p "press any key to continue"

grep -B1 '^ /usr/include' dummy.log
read -n 1 -s -p "press any key to continue"

grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
read -n 1 -s -p "press any key to continue"

grep "/lib.*/libc.so.6 " dummy.log
read -n 1 -s -p "press any key to continue"

grep found dummy.log
read -n 1 -s -p "press any key to continue"

rm -v dummy.c a.out dummy.log

#6.11 Zlib
printf "\n\n 6.11 Zlib\n"
cd /sources
rm -rf zlib-1.2.11
tar -xf zlib-1.2.11.tar.xz
cd zlib-1.2.11

./configure --prefix=/usr
make
make install
read -n 1 -s -p "press any key to continue"
mv -v /usr/lib/libz.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libz.so) /usr/lib/libz.so

cd /sources
rm -rf zlib-1.2.11

#6.12 File
printf "\n\n 6.12 File\n"
cd /sources
rm -rf file-5.31
tar -xf file-5.31.tar.gz
cd file-5.31

./configure --prefix=/usr
make
make install
read -n 1 -s -p "press any key to continue"

cd /sources
rm -rf file-5.31

#6.13 Readline
printf "\n\n 6.13 Readline\n"
cd /sources
rm -rf readline-7.0
tar -xf readline-7.0.tar.gz
cd readline-7.0

sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/readline-7.0
make SHLIB_LIBS="-L/tools/lib -lncursesw"
make SHLIB_LIBS="-L/tools/lib -lncurses" install
read -n 1 -s -p "press any key to continue"

mv -v /usr/lib/lib{readline,history}.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so
ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so
install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-7.0

cd /sources
rm -rf readline-7.0

#6.14 M4
printf "\n\n 6.14 M4\n"
cd /sources
rm -rf m4-1.4.18
tar -xf m4-1.4.18.tar.xz
cd m4-1.4.18

./configure --prefix=/usr
make
make install
read -n 1 -s -p "press any key to continue"

cd /sources
rm -rf m4-1.4.18

#6.15 Bc
printf "\n\n 6.15 Bc\n"
cd /sources
rm -rf bc-1.07.1
tar -xf bc-1.07.1.tar.gz
cd bc-1.07.1

cat > bc/fix-libmath_h << "EOF"
#! /bin/bash
sed -e '1   s/^/{"/' \
    -e     's/$/",/' \
    -e '2,$ s/^/"/'  \
    -e   '$ d'       \
    -i libmath.h

sed -e '$ s/$/0}/' \
    -i libmath.h
EOF

ln -sv /tools/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6
ln -sfv libncurses.so.6 /usr/lib/libncurses.so

sed -i -e '/flex/s/as_fn_error/: ;; # &/' configure

./configure --prefix=/usr           \
            --with-readline         \
            --mandir=/usr/share/man \
            --infodir=/usr/share/info
make
make install
read -n 1 -s -p "press any key to continue"

cd /sources
rm -rf bc-1.07.1

#6.16 Binutils
printf "\n\n 6.16 Binutils\n"
cd /sources
rm -rf binutils-2.29
tar -xjf binutils-2.29.tar.bz2
cd binutils-2.29

expect -c "spawn ls"
read -n 1 -s -p "press any key to continue"

mkdir -v build
cd       build
../configure --prefix=/usr       \
             --enable-gold       \
             --enable-ld=default \
             --enable-plugins    \
             --enable-shared     \
             --disable-werror    \
             --with-system-zlib
make tooldir=/usr
make -k check
read -n 1 -s -p "press any key to continue"

make tooldir=/usr install
read -n 1 -s -p "press any key to continue"

cd /sources
rm -rf binutils-2.29

#6.17 GMP-6.1.2
printf "\n\n 6.17 GMP\n"
cd /sources
rm -rf gmp-6.1.2
tar -xf gmp-6.1.2.tar.xz
cd gmp-6.1.2

cp -v configfsf.guess config.guess
cp -v configfsf.sub   config.sub
./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.1.2
make
make html
read -n 1 -s -p "press any key to continue"

make check 2>&1 | tee gmp-check-log
read -n 1 -s -p "press any key to continue"

awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log
read -n 1 -s -p "press any key to continue"

make install
make install-html
read -n 1 -s -p "press any key to continue"

cd /sources
rm -rf gmp-6.1.2

#6.18. MPFR
printf "\n\n 6.18 MPFR\n"
cd /sources
rm -rf mpfr-3.1.5
tar -xf mpfr-3.1.5.tar.xz
cd mpfr-3.1.5

./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-3.1.5
make
make html
read -n 1 -s -p "press any key to continue"

make check
read -n 1 -s -p "press any key to continue"

make install
make install-html
read -n 1 -s -p "press any key to continue"

cd /sources
rm -rf mpfr-3.1.5


#6.19. MPC
printf "\n\n 6.19 MPC\n"
cd /sources
rm -rf mpc-1.0.3
tar -xf mpc-1.0.3.tar.gz
cd mpc-1.0.3

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/mpc-1.0.3
make
make html
make install
make install-html
read -n 1 -s -p "press any key to continue"

cd /sources
rm -rf mpc-1.0.3

#6.20. GCC
printf "\n\n 6.20 GCC\n"
cd /sources
rm -rf gcc-7.2.0
tar -xf gcc-7.2.0.tar.xz
cd gcc-7.2.0

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac

rm -f /usr/lib/gcc
mkdir -v build
cd       build
SED=sed                               \
../configure --prefix=/usr            \
             --enable-languages=c,c++ \
             --disable-multilib       \
             --disable-bootstrap      \
             --with-system-zlib
make
read -n 1 -s -p "press any key to continue"

ulimit -s 32768
make -k check
read -n 1 -s -p "press any key to continue"

../contrib/test_summary
read -n 1 -s -p "press any key to continue"

make install
ln -sv ../usr/bin/cpp /lib
ln -sv gcc /usr/bin/cc
install -v -dm755 /usr/lib/bfd-plugins
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/7.2.0/liblto_plugin.so \
        /usr/lib/bfd-plugins/

echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
read -n 1 -s -p "press any key to continue - [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]"

grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
read -n 1 -s -p "press any key to continue"

grep -B4 '^ /usr/include' dummy.log
read -n 1 -s -p "press any key to continue"

grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
read -n 1 -s -p "press any key to continue"

grep "/lib.*/libc.so.6 " dummy.log
read -n 1 -s -p "press any key to continue"

grep found dummy.log
read -n 1 -s -p "press any key to continue"

rm -v dummy.c a.out dummy.log
mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib

cd /sources
rm -rf gcc-7.2.0

#6.21. Bzip2
printf "\n\n 6.21. Bzip2\n"
cd /sources
rm -rf bzip2-1.0.6
tar -xf bzip2-1.0.6.tar.gz
cd bzip2-1.0.6

patch -Np1 -i ../bzip2-1.0.6-install_docs-1.patch
sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile
make -f Makefile-libbz2_so
make clean

make
make PREFIX=/usr install
read -n 1 -s -p "press any key to continue"

cp -v bzip2-shared /bin/bzip2
cp -av libbz2.so* /lib
ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so
rm -v /usr/bin/{bunzip2,bzcat,bzip2}
ln -sv bzip2 /bin/bunzip2
ln -sv bzip2 /bin/bzcat

cd /sources
rm -rf bzip2-1.0.6

#6.22. Pkg-config
printf "\n\n 6.22. Pkg-config\n"
cd /sources
rm -rf pkg-config-0.29.2
tar -xf pkg-config-0.29.2.tar.gz
cd pkg-config-0.29.2

./configure --prefix=/usr              \
            --with-internal-glib       \
            --disable-host-tool        \
            --docdir=/usr/share/doc/pkg-config-0.29.2
make
make install
read -n 1 -s -p "press any key to continue"

cd /sources
rm -rf pkg-config-0.29.2

#6.23. Ncurses
printf "\n\n 6.23. Ncurses\n"
cd /sources
rm -rf ncurses-6.0
tar -xf ncurses-6.0.tar.gz
cd ncurses-6.0

sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-normal        \
            --enable-pc-files       \
            --enable-widec
make
make install
read -n 1 -s -p "press any key to continue"

mv -v /usr/lib/libncursesw.so.6* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libncursesw.so) /usr/lib/libncursesw.so
for lib in ncurses form panel menu ; do
    rm -vf                    /usr/lib/lib${lib}.so
    echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc        /usr/lib/pkgconfig/${lib}.pc
done

rm -vf                     /usr/lib/libcursesw.so
echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
ln -sfv libncurses.so      /usr/lib/libcurses.so

cd /sources
rm -rf ncurses-6.0

#6.24. Attr
printf "\n\n 6.23. Ncurses\n"
cd /sources
rm -rf attr-2.4.47
tar -xf attr-2.4.47.src.tar.gz
cd attr-2.4.47

sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
sed -i -e "/SUBDIRS/s|man[25]||g" man/Makefile
sed -i 's:{(:\\{(:' test/run
./configure --prefix=/usr \
            --bindir=/bin \
            --disable-static
make
make -j1 tests root-tests
read -n 1 -s -p "press any key to continue"

make install install-dev install-lib
chmod -v 755 /usr/lib/libattr.so
mv -v /usr/lib/libattr.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so

cd /sources
rm -rf attr-2.4.47.src

