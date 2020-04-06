#!/bin/bash
printf "==================== 3-lfs.sh ====================\n"

export LFS=/mnt/lfs
set -u

#5.4 Binutils
printf "\n\n5.4 Binutils\n"
cd $LFS/sources
rm -rf binutils-2.29
tar -xjf binutils-2.29.tar.bz2
cd binutils-2.29
mkdir -p build
cd       build

../configure --prefix=/tools            \
             --with-sysroot=$LFS        \
             --with-lib-path=/tools/lib \
             --target=$LFS_TGT          \
             --disable-nls              \
             --disable-werror

make

case $(uname -m) in
  x86_64) mkdir -p /tools/lib && ln -sf lib /tools/lib64 ;;
esac

make install
read -n 1 -s -p "press any key to continue"
cd $LFS/sources
rm -rf binutils-2.29

#5.5 GCC
printf "\n\n5.5 GCC\n"
cd $LFS/sources
rm -rf gcc-7.2.0
tar -xf gcc-7.2.0.tar.xz
cd gcc-7.2.0

tar -xf ../mpfr-3.1.5.tar.xz
mv -v mpfr-3.1.5 mpfr
tar -xf ../gmp-6.1.2.tar.xz
mv -v gmp-6.1.2 gmp
tar -xf ../mpc-1.0.3.tar.gz
mv -v mpc-1.0.3 mpc

for file in gcc/config/{linux,i386/linux{,64}}.h
do
  cp -u $file{,.orig}
  sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
      -e 's@/usr@/tools@g' $file.orig > $file
  echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
  touch $file.orig
done

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
 ;;
esac

mkdir 	build
cd       build

../configure                                       \
    --target=$LFS_TGT                              \
    --prefix=/tools                                \
    --with-glibc-version=2.11                      \
    --with-sysroot=$LFS                            \
    --with-newlib                                  \
    --without-headers                              \
    --with-local-prefix=/tools                     \
    --with-native-system-header-dir=/tools/include \
    --disable-nls                                  \
    --disable-shared                               \
    --disable-multilib                             \
    --disable-decimal-float                        \
    --disable-threads                              \
    --disable-libatomic                            \
    --disable-libgomp                              \
    --disable-libmpx                               \
    --disable-libquadmath                          \
    --disable-libssp                               \
    --disable-libvtv                               \
    --disable-libstdcxx                            \
    --enable-languages=c,c++

make
make install
read -n 1 -s -p "press any key to continue"
cd $LFS/sources
rm -rf gcc-7.2.0

#5.6 Linux
printf "\n\n5.6 Linux\n"
cd $LFS/sources
rm -rf linux-4.12.7
tar -xf linux-4.12.7.tar.xz
cd linux-4.12.7

make mrproper
make INSTALL_HDR_PATH=dest headers_install
read -n 1 -s -p "press any key to continue"
cp -ur dest/include/* /tools/include

cd $LFS/sources
rm -rf linux-4.12.7

#5.7 Glibc
printf "\n\n5.7 Glibc\n"
cd $LFS/sources
rm -rf glibc-2.26
tar -xf glibc-2.26.tar.xz 
cd glibc-2.26
mkdir build
cd       build

../configure                             \
      --prefix=/tools                    \
      --host=$LFS_TGT                    \
      --build=$(../scripts/config.guess) \
      --enable-kernel=3.2             \
      --with-headers=/tools/include      \
      libc_cv_forced_unwind=yes          \
      libc_cv_c_cleanup=yes

make
make install

echo 'int main(){}' > dummy.c
$LFS_TGT-gcc dummy.c
readelf -l a.out | grep ': /tools'
rm dummy.c a.out
read -n 1 -s -p "press any key to continue"

cd $LFS/sources
rm -rf glibc-2.26

#5.8 Libstdc
printf "\n\n5.8 Libstdc\n"
cd $LFS/sources
rm -rf gcc-7.2.0
tar -xf gcc-7.2.0.tar.xz
cd gcc-7.2.0

mkdir  build
cd       build

../libstdc++-v3/configure           \
    --host=$LFS_TGT                 \
    --prefix=/tools                 \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-threads     \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/7.2.0

make
make install
read -n 1 -s -p "press any key to continue"
cd $LFS/sources
rm -rf gcc-7.2.0

#5.9 Binutils
printf "\n\n5.9 Binutils\n"
cd $LFS/sources
rm -rf binutils-2.29
tar -xjf binutils-2.29.tar.bz2
cd binutils-2.29

mkdir build
cd       build

CC=$LFS_TGT-gcc                \
AR=$LFS_TGT-ar                 \
RANLIB=$LFS_TGT-ranlib         \
../configure                   \
    --prefix=/tools            \
    --disable-nls              \
    --disable-werror           \
    --with-lib-path=/tools/lib \
    --with-sysroot

make
make install
read -n 1 -s -p "press any key to continue"
make -C ld clean
make -C ld LIB_PATH=/usr/lib:/lib
cp -u ld/ld-new /tools/bin

cd $LFS/sources
rm -rf binutils-2.29

#5.10 GCC
printf "\n\n5.10 GCC\n"
cd $LFS/sources
rm -rf gcc-7.2.0
tar -xf gcc-7.2.0.tar.xz
cd gcc-7.2.0

cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include-fixed/limits.h

for file in gcc/config/{linux,i386/linux{,64}}.h
do
  cp -u $file{,.orig}
  sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
      -e 's@/usr@/tools@g' $file.orig > $file
  echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
  touch $file.orig
done

case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac

tar -xf ../mpfr-3.1.5.tar.xz
mv -v mpfr-3.1.5 mpfr
tar -xf ../gmp-6.1.2.tar.xz
mv -v gmp-6.1.2 gmp
tar -xf ../mpc-1.0.3.tar.gz
mv -v mpc-1.0.3 mpc

mkdir  build
cd       build

CC=$LFS_TGT-gcc                                    \
CXX=$LFS_TGT-g++                                   \
AR=$LFS_TGT-ar                                     \
RANLIB=$LFS_TGT-ranlib                             \
../configure                                       \
    --prefix=/tools                                \
    --with-local-prefix=/tools                     \
    --with-native-system-header-dir=/tools/include \
    --enable-languages=c,c++                       \
    --disable-libstdcxx-pch                        \
    --disable-multilib                             \
    --disable-bootstrap                            \
    --disable-libgomp

make
make install
ln -sf gcc /tools/bin/cc
read -n 1 -s -p "press any key to continue"

cd $LFS/sources
rm -rf gcc-7.2.0

#5.11 Tcl
printf "\n\n5.11 Tcl\n"
cd $LFS/sources
rm -rf tcl8.6.7
tar -xf tcl-core8.6.7-src.tar.gz
cd tcl8.6.7

cd unix
./configure --prefix=/tools

make
make install
chmod -v u+w /tools/lib/libtcl8.6.so
make install-private-headers
ln -sf tclsh8.6 /tools/bin/tclsh
read -n 1 -s -p "press any key to continue"

cd $LFS/sources
rm -rf tcl8.6.7

#5.12 Expect
printf "\n\n5.12 Expect\n"
cd $LFS/sources
rm -rf expect5.45
tar -xf expect5.45.tar.gz 
cd expect5.45

cp -f configure{,.orig}
sed 's:/usr/local/bin:/bin:' configure.orig > configure

./configure --prefix=/tools       \
            --with-tcl=/tools/lib \
            --with-tclinclude=/tools/include

make
make SCRIPTS="" install
read -n 1 -s -p "press any key to continue"

cd $LFS/sources
rm -rf expect5.45

#5.13 DejaGNU
printf "\n\n5.13 DejaGNU\n"
cd $LFS/sources
rm -rf dejagnu-1.6
tar -xf dejagnu-1.6.tar.gz 
cd dejagnu-1.6

./configure --prefix=/tools
make install
read -n 1 -s -p "press any key to continue"

cd $LFS/sources
rm -rf expect5.45

#5.14 Check
printf "\n\n5.14 Check\n"
cd $LFS/sources
rm -rf check-0.11.0
tar -xf check-0.11.0.tar.gz
cd check-0.11.0

PKG_CONFIG= ./configure --prefix=/tools
make
make install
read -n 1 -s -p "press any key to continue"

cd $LFS/sources
rm -rf check-0.11.0

#5.15 Ncurses
printf "\n\n5.15 Ncurses\n"
cd $LFS/sources
rm -rf ncurses-6.0
tar -xf ncurses-6.0.tar.gz
cd ncurses-6.0

sed -i s/mawk// configure

./configure --prefix=/tools \
            --with-shared   \
            --without-debug \
            --without-ada   \
            --enable-widec  \
            --enable-overwrite

make
make install
read -n 1 -s -p "press any key to continue"

cd $LFS/sources
rm -rf ncurses-6.0

