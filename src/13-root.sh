printf " =========================== 13-root.sh =========================== \n"

#6.52. Gawk
printf "\n\n 6.52 Gawk\n"
cd /sources
rm -rf gawk-4.1.4
tar -xf gawk-4.1.4.tar.xz
cd gawk-4.1.4

./configure --prefix=/usr
make
make install
read -n 1 -s -p "press any key to continue"

cd /sources
rm -rf gawk-4.1.4

#6.53. Findutils
printf "\n\n 6.53 Findutils\n"
cd /sources
rm -rf findutils-4.6.0
tar -xf findutils-4.6.0.tar.gz
cd findutils-4.6.0

sed -i 's/test-lock..EXEEXT.//' tests/Makefile.in
./configure --prefix=/usr --localstatedir=/var/lib/locate
make
make install
read -n 1 -s -p "press any key to continue"

mv -v /usr/bin/find /bin
sed -i 's|find:=${BINDIR}|find:=/bin|' /usr/bin/updatedb

cd /sources
rm -rf findutils-4.6.0

#6.54. Groff
printf "\n\n 6.54 Groff\n"
cd /sources
rm -rf groff-1.22.3
tar -xf groff-1.22.3.tar.gz
cd groff-1.22.3

PAGE=<paper_size> ./configure --prefix=/usr
make -j1
make install
read -n 1 -s -p "press any key to continue"

cd /sources
rm -rf groff-1.22.3

#6.55. GRUB
printf "\n\n 6.55 GRUB\n"
cd /sources
rm -rf grub-2.02
tar -xf grub-2.02.tar.xz
cd grub-2.02

./configure --prefix=/usr          \
            --sbindir=/sbin        \
            --sysconfdir=/etc      \
            --disable-efiemu       \
            --disable-werror
make
make install
read -n 1 -s -p "press any key to continue"

cd /sources
rm -rf grub-2.02

#6.56. Less
printf "\n\n 6.56 Less\n"
cd /sources
rm -rf less-487
tar -xf less-487.tar.gz
cd less-487

./configure --prefix=/usr --sysconfdir=/etc
make
make install
read -n 1 -s -p "press any key to continue"

cd /sources
rm -rf less-487

#6.57. Gzip
printf "\n\n 6.57 Gzip\n"
cd /sources
rm -rf gzip-1.8
tar -xf gzip-1.8.tar.xz
cd gzip-1.8

./configure --prefix=/usr
make
make install
read -n 1 -s -p "press any key to continue"
mv -v /usr/bin/gzip /bin

cd /sources
rm -rf gzip-1.8

#6.58. IPRoute2
printf "\n\n 6.58 IPRoute2\n"
cd /sources
rm -rf iproute2-4.12.0
tar -xf iproute2-4.12.0.tar.xz
cd iproute2-4.12.0

sed -i /ARPD/d Makefile
sed -i 's/arpd.8//' man/man8/Makefile
rm -v doc/arpd.sgml
sed -i 's/m_ipt.o//' tc/Makefile
make
make DOCDIR=/usr/share/doc/iproute2-4.12.0 install
read -n 1 -s -p "press any key to continue"

cd /sources
rm -rf iproute2-4.12.0

#6.59. Kbd
printf "\n\n 6.59 Kbd\n"
cd /sources
rm -rf kbd-2.0.4
tar -xf kbd-2.0.4.tar.xz
cd kbd-2.0.4

patch -Np1 -i ../kbd-2.0.4-backspace-1.patch
sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure --prefix=/usr --disable-vlock
make
make install
read -n 1 -s -p "press any key to continue"

cd /sources
rm -rf kbd-2.0.4

#6.60. Libpipeline
printf "\n\n 6.60. Libpipeline\n"
cd /sources
rm -rf libpipeline-1.4.2
tar -xf libpipeline-1.4.2.tar.gz
cd libpipeline-1.4.2

PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure --prefix=/usr
make
make install
read -n 1 -s -p "press any key to continue"

cd /sources
rm -rf libpipeline-1.4.2

#6.61. Make
printf "\n\n 6.61. Make\n"
cd /sources
rm -rf make-4.2.1
tar -xjf make-4.2.1.tar.bz2
cd make-4.2.1

./configure --prefix=/usr
make
make install
read -n 1 -s -p "press any key to continue"

cd /sources
rm -rf make-4.2.1

#6.62. Patch
printf "\n\n 6.62. Patch\n"
cd /sources
rm -rf patch-2.7.5
tar -xf patch-2.7.5.tar.xz
cd patch-2.7.5

./configure --prefix=/usr
make
make install
read -n 1 -s -p "press any key to continue"

cd /sources
rm -rf patch-2.7.5

#6.63. Sysklogd
printf "\n\n 6.63. Sysklogd\n"
cd /sources
rm -rf sysklogd-1.5.1
tar -xf sysklogd-1.5.1.tar.gz
cd sysklogd-1.5.1

sed -i '/Error loading kernel symbols/{n;n;d}' ksym_mod.c
sed -i 's/union wait/int/' syslogd.c
make
make BINDIR=/sbin install
read -n 1 -s -p "press any key to continue"

cat > /etc/syslog.conf << "EOF"
# Begin /etc/syslog.conf

auth,authpriv.* -/var/log/auth.log
*.*;auth,authpriv.none -/var/log/sys.log
daemon.* -/var/log/daemon.log
kern.* -/var/log/kern.log
mail.* -/var/log/mail.log
user.* -/var/log/user.log
*.emerg *

# End /etc/syslog.conf
EOF

cd /sources
rm -rf sysklogd-1.5.1

#6.64. Sysvinit
printf "\n\n 6.64. Sysklogd\n"
cd /sources
rm -rf sysvinit-2.88dsf
tar -xjf sysvinit-2.88dsf.tar.bz2
cd sysvinit-2.88dsf

patch -Np1 -i ../sysvinit-2.88dsf-consolidated-1.patch
make -C src
make -C src install
read -n 1 -s -p "press any key to continue"

cd /sources
rm -rf sysvinit-2.88dsf

#6.65. Eudev
printf "\n\n 6.65. Eudev\n"
cd /sources
rm -rf eudev-3.2.2
tar -xf eudev-3.2.2.tar.gz
cd eudev-3.2.2

sed -r -i 's|/usr(/bin/test)|\1|' test/udev-test.pl
sed -i '/keyboard_lookup_key/d' src/udev/udev-builtin-keyboard.c
cat > config.cache << "EOF"
HAVE_BLKID=1
BLKID_LIBS="-lblkid"
BLKID_CFLAGS="-I/tools/include"
EOF
./configure --prefix=/usr           \
            --bindir=/sbin          \
            --sbindir=/sbin         \
            --libdir=/usr/lib       \
            --sysconfdir=/etc       \
            --libexecdir=/lib       \
            --with-rootprefix=      \
            --with-rootlibdir=/lib  \
            --enable-manpages       \
            --disable-static        \
            --config-cache
LIBRARY_PATH=/tools/lib make
mkdir -pv /lib/udev/rules.d
mkdir -pv /etc/udev/rules.d
make LD_LIBRARY_PATH=/tools/lib install
tar -xvf ../udev-lfs-20140408.tar.bz2
make -f udev-lfs-20140408/Makefile.lfs install
read -n 1 -s -p "press any key to continue"

LD_LIBRARY_PATH=/tools/lib udevadm hwdb --update

cd /sources
rm -rf eudev-3.2.2

#6.66. Util-linux
printf "\n\n 6.66 Util-linux\n"
cd /sources
rm -rf util-linux-2.30.1
tar -xf util-linux-2.30.1.tar.xz
cd util-linux-2.30.1

mkdir -pv /var/lib/hwclock
./configure ADJTIME_PATH=/var/lib/hwclock/adjtime   \
            --docdir=/usr/share/doc/util-linux-2.30.1 \
            --disable-chfn-chsh  \
            --disable-login      \
            --disable-nologin    \
            --disable-su         \
            --disable-setpriv    \
            --disable-runuser    \
            --disable-pylibmount \
            --disable-static     \
            --without-python     \
            --without-systemd    \
            --without-systemdsystemunitdir
make
make install
read -n 1 -s -p "press any key to continue"

cd /sources
rm -rf util-linux-2.30.1

#6.67. Man-DB
printf "\n\n 6.67 Man-DB\n"
cd /sources
rm -rf man-db-2.7.6.1
tar -xf man-db-2.7.6.1.tar.xz
cd man-db-2.7.6.1

./configure --prefix=/usr                        \
            --docdir=/usr/share/doc/man-db-2.7.6.1 \
            --sysconfdir=/etc                    \
            --disable-setuid                     \
            --enable-cache-owner=bin             \
            --with-browser=/usr/bin/lynx         \
            --with-vgrind=/usr/bin/vgrind        \
            --with-grap=/usr/bin/grap            \
            --with-systemdtmpfilesdir=
make
make install
read -n 1 -s -p "press any key to continue"

cd /sources
rm -rf man-db-2.7.6.1

#6.68. Tar
printf "\n\n 6.68 Tar\n"
cd /sources
rm -rf tar-1.29
tar -xf tar-1.29.tar.xz
cd tar-1.29

FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr \
            --bindir=/bin
make
make install
make -C doc install-html docdir=/usr/share/doc/tar-1.29
read -n 1 -s -p "press any key to continue"

cd /sources
rm -rf tar-1.29

#6.69. Texinfo
printf "\n\n 6.69 Texinfo\n"
cd /sources
rm -rf texinfo-6.4
tar -xf texinfo-6.4.tar.xz
cd texinfo-6.4

./configure --prefix=/usr --disable-static
make
make install
read -n 1 -s -p "press any key to continue"

pushd /usr/share/info
rm -v dir
for f in *
  do install-info $f dir 2>/dev/null
done
popd

cd /sources
rm -rf texinfo-6.4

#6.70. Vim
printf "\n\n 6.70 Vim\n"
cd /sources
rm -rf vim-8.0.586
tar -xjf vim-8.0.586.tar.bz2
cd vim-8.0.586

echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
sed -i '/call/{s/split/xsplit/;s/303/492/}' src/testdir/test_recover.vim
./configure --prefix=/usr
make
make install
read -n 1 -s -p "press any key to continue"

ln -sv vim /usr/bin/vi
for L in  /usr/share/man/{,*/}man1/vim.1; do
    ln -sv vim.1 $(dirname $L)/vi.1
done
ln -sv ../vim/vim80/doc /usr/share/doc/vim-8.0.586

cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

set nocompatible
set backspace=2
set mouse=r
syntax on
if (&term == "xterm") || (&term == "putty")
  set background=dark
endif


" End /etc/vimrc
EOF

touch ~/.vimrc

cd /sources
rm -rf vim-8.0.586




