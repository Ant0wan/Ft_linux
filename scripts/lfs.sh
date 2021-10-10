#!/bin/bash

export LFS=/mnt/lfs
export LFS_TGT=x86_64-lfs-linux-gnu
export LFS_DISK=/dev/sda

if ! grep -q "^${LFS}" /proc/mounts; then
	parted ${LFS_DISK} mklabel gpt

	parted ${LFS_DISK} mkpart primary ext4 1 100MB
	mkfs.ext4 ${LFS_DISK}1
	parted ${LFS_DISK} set 1 boot on

	parted ${LFS_DISK} mkpart primary ext4 100MB 50GB
	mkfs.ext4 ${LFS_DISK}2
	mkdir -p $LFS
	mount ${LFS_DISK}2 $LFS
fi

mkdir -pv ${LFS}/{sources,tools,boot,etc,bin,lib,sbin,usr,var}
chown -v ${LFS}/{sources,tools,boot,etc,bin,lib,sbin,usr,var}
case $(uname -m) in
	x86_64) mkdir -pv lfs ${LFS}/lib64 && chown -v lfs ${LFS}/lib64 ;;
esac
