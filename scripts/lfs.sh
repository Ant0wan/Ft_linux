#!/bin/bash

export LFS=/mnt/lfs
export LFS_TGT=x86_64-lfs-linux-gnu
export LFS_DISK=/dev/sdb

if ! grep -q "^${LFS}" /proc/mounts; then
	parted $LFS_DISK mklabel gpt
	parted /dev/sdb mkpart primary ext4 1MB 500GB
