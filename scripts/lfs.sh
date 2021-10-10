#!/bin/bash
set -e

export LFS=/mnt/lfs
export LFS_TGT=x86_64-lfs-linux-gnu
export LFS_DISK=/dev/sda

if ! grep -q "${LFS}" /proc/mounts; then
	parted ${LFS_DISK} mklabel gpt

	parted ${LFS_DISK} mkpart primary ext4 1 100MB
	mkfs.ext4 ${LFS_DISK}1
	parted ${LFS_DISK} set 1 boot on

	parted ${LFS_DISK} mkpart primary ext4 100MB 50GB
	mkfs.ext4 ${LFS_DISK}2
	mkdir -p $LFS
	mount ${LFS_DISK}2 $LFS
fi

mkdir -vp ${LFS}/{sources,tools,boot,etc,bin,lib,sbin,usr,var}
chown -v lfs ${LFS}/{sources,tools,boot,etc,bin,lib,sbin,usr,var}
case $(uname -m) in
	x86_64) mkdir -pv ${LFS}/lib64 && chown -v lfs ${LFS}/lib64 ;;
esac

export PATH=${LFS}/tools/bin:$PATH
while read -r line; do
	wget $(echo $line | cut -d ';' -f3) --directory-prefix=${LFS}/sources/
done < packages.csv
