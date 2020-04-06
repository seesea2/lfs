#!/bin/bash
printf "==================== 5-lfs.sh =======================\n"

export LFS=/mnt/lfs
set -u

#5.17 Bison
printf "\n\n5.17 Bison\n"
cd $LFS/sources
rm -rf bison-3.0.4
tar -xf bison-3.0.4.tar.xz
cd bison-3.0.4

./configure --prefix=/tools
make
make install
read -n 1 -s -p "press any key to continue"

cd $LFS/sources
rm -rf bison-3.0.4

#5.18 Bzip2
cd $LFS/sources
printf "\n\n5.18 Bzip2\n"
rm -rf bzip2-1.0.6
tar -xf bzip2-1.0.6.tar.gz 
cd bzip2-1.0.6

make
make PREFIX=/tools install
read -n 1 -s -p "press any key to continue"

cd $LFS/sources
rm -rf bzip2-1.0.6

#5.19 Coreutils
cd $LFS/sources
printf "\n\n5.19 Coreutils\n"
rm -rf coreutils-8.27
tar -xf coreutils-8.27.tar.xz 
cd coreutils-8.27

./configure --prefix=/tools --enable-install-program=hostname
make
make install
read -n 1 -s -p "press any key to continue"

cd $LFS/sources
rm -rf coreutils-8.27

#5.20 Diffutils
cd $LFS/sources
printf "\n\n5.20 Diffutils\n"
rm -rf diffutils-3.6
tar -xf diffutils-3.6.tar.xz
cd diffutils-3.6

./configure --prefix=/tools
make
make install
read -n 1 -s -p "press any key to continue"

cd $LFS/sources
rm -rf diffutils-3.6

#5.21 File
cd $LFS/sources
printf "\n\n5.21 File\n"
rm -rf file-5.31
tar -xf file-5.31.tar.gz
cd file-5.31

./configure --prefix=/tools
make
make install
read -n 1 -s -p "press any key to continue"

cd $LFS/sources
rm -rf file-5.31

#5.22 Findutils
cd $LFS/sources
printf "\n\n5.22 Findutils\n"
rm -rf findutils-4.6.0
tar -xf findutils-4.6.0.tar.gz 
cd findutils-4.6.0

./configure --prefix=/tools
make
make install
read -n 1 -s -p "press any key to continue"

cd $LFS/sources
rm -rf findutils-4.6.0

#5.23 Gawk
cd $LFS/sources
printf "\n\n5.23 Gawk\n"
rm -rf gawk-4.1.4
tar -xf gawk-4.1.4.tar.xz
cd gawk-4.1.4

./configure --prefix=/tools
make
make install
read -n 1 -s -p "press any key to continue"

cd $LFS/sources
rm -rf gawk-4.1.4

#5.24 Gettext
cd $LFS/sources
printf "\n\n5.24 Gettext\n"
rm -rf gettext-0.19.8.1
tar -xf gettext-0.19.8.1.tar.xz
cd gettext-0.19.8.1

cd gettext-tools
EMACS="no" ./configure --prefix=/tools --disable-shared
make -C gnulib-lib
make -C intl pluralx.c
make -C src msgfmt
make -C src msgmerge
make -C src xgettext
cp -vf src/{msgfmt,msgmerge,xgettext} /tools/bin
read -n 1 -s -p "press any key to continue"

cd $LFS/sources
rm -rf gettext-0.19.8.1

#5.25 Grep
cd $LFS/sources
printf "\n\n5.25 Grep\n"
rm -rf grep-3.1
tar -xf grep-3.1.tar.xz
cd grep-3.1

./configure --prefix=/tools
make
make install
read -n 1 -s -p "press any key to continue"

cd $LFS/sources
rm -rf grep-3.1

#5.26 Gzip
cd $LFS/sources
printf "\n\n5.26 Gzip\n"
rm -rf gzip-1.8
tar -xf gzip-1.8.tar.xz
cd gzip-1.8

./configure --prefix=/tools
make
make install
read -n 1 -s -p "press any key to continue"

cd $LFS/sources
rm -rf gzip-1.8

#5.27 M4
cd $LFS/sources
printf "\n\n5.27 M4\n"
rm -rf m4-1.4.18
tar -xf m4-1.4.18.tar.xz
cd m4-1.4.18

./configure --prefix=/tools
make
make install
read -n 1 -s -p "press any key to continue"

cd $LFS/sources
rm -rf m4-1.4.18

#5.28 Make
cd $LFS/sources
printf "\n\n5.28 Make\n"
rm -rf make-4.2.1
tar -xjf make-4.2.1.tar.bz2
cd make-4.2.1

./configure --prefix=/tools --without-guile
make
make install
read -n 1 -s -p "press any key to continue"

cd $LFS/sources
rm -rf make-4.2.1

#5.29 Patch
cd $LFS/sources
printf "\n\n5.29 Patch\n"
rm -rf patch-2.7.5
tar -xf patch-2.7.5.tar.xz
cd patch-2.7.5
./configure --prefix=/tools
make
make install
read -n 1 -s -p "press any key to continue"

cd $LFS/sources
rm -rf patch-2.7.5

#5.30 Perl
cd $LFS/sources
printf "\n\n5.30 Perl\n"
rm -rf perl-5.26.0
tar -xf perl-5.26.0.tar.xz
cd perl-5.26.0
sed -e '9751 a#ifndef PERL_IN_XSUB_RE' \
    -e '9808 a#endif'                  \
    -i regexec.c
sh Configure -des -Dprefix=/tools -Dlibs=-lm
make
read -n 1 -s -p "press any key to continue"
cp -f perl cpan/podlators/scripts/pod2man /tools/bin
mkdir -p /tools/lib/perl5/5.26.0
cp -Rf lib/* /tools/lib/perl5/5.26.0
cd $LFS/sources
rm -rf perl-5.26.0

#5.31 Sed
cd $LFS/sources
printf "\n\n5.31 Sed\n"
rm -rf sed-4.4
tar -xf sed-4.4.tar.xz
cd sed-4.4
./configure --prefix=/tools
make
make install
read -n 1 -s -p "press any key to continue"
cd $LFS/sources
rm -rf sed-4.4

#5.32 Tar
cd $LFS/sources
printf "\n\n5.32 Tar\n"
rm -rf tar-1.29
tar -xf tar-1.29.tar.xz
cd tar-1.29
./configure --prefix=/tools
make
make install
read -n 1 -s -p "press any key to continue"
cd $LFS/sources
rm -rf tar-1.29

#5.33 Texinfo
cd $LFS/sources
printf "\n\n5.33 Texinfo\n"
rm -rf texinfo-6.4
tar -xf texinfo-6.4.tar.xz
cd texinfo-6.4
./configure --prefix=/tools
make
make install
read -n 1 -s -p "press any key to continue"
cd $LFS/sources
rm -rf texinfo-6.4

#5.34 Util-linux
cd $LFS/sources
printf "\n\n5.34 Util-linux\n"
rm -rf util-linux-2.30.1
tar -xf util-linux-2.30.1.tar.xz
cd util-linux-2.30.1
./configure --prefix=/tools                \
            --without-python               \
            --disable-makeinstall-chown    \
            --without-systemdsystemunitdir \
            --without-ncurses              \
            PKG_CONFIG=""
make
make install
read -n 1 -s -p "press any key to continue"
cd $LFS/sources
rm -rf util-linux-2.30.1

#5.35 Xz
cd $LFS/sources
printf "\n\n5.35 Xz\n"
rm -rf xz-5.2.3
tar -xf xz-5.2.3.tar.xz
cd xz-5.2.3
./configure --prefix=/tools
make
make install
read -n 1 -s -p "press any key to continue"
cd $LFS/sources
rm -rf xz-5.2.3

#5.36 Stripping
cd $LFS/sources
printf "\n\n5.36 Stripping\n"
strip --strip-debug /tools/lib/*
/usr/bin/strip --strip-unneeded /tools/{,s}bin/*
rm -rf /tools/{,share}/{info,man,doc}

exit
exit
exit



