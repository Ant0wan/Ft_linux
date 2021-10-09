#!/bin/bash

export LFS=/mnt/lfs
export LFS_TGT=x86_64-lfs-linux-gnu
export LFS_DISK=/dev/sda

if ! grep -q "^${LFS}" /proc/mounts; then
	parted ${LFS_DISK} mklabel gpt
	parted ${LFS_DISK} mkpart primary ext4 1 100MB
	mkfs.ext4 ${LFS_DISK}1
	parted ${LFS_DISK} set 1 boot on
fi
