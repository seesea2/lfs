#!/bin/bash
echo "1-root.sh"

set -u
export LFS=/mnt/lfs
mkdir -p $LFS
#mount -t ext4 /dev/sdb1 $LFS

mkdir -p $LFS/sources
chmod a+wt $LFS/sources
mkdir -p $LFS/tools
ln -sf $LFS/tools /

groupadd -f lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
chown -v lfs $LFS/tools
chown -v lfs $LFS/sources

su - lfs

