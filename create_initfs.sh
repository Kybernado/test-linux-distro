#!/bin/bash

function print_usage {
	echo "Usage: $0 <initfs-folder>"
}

if [ -z "$1" ]; then
	print_usage
	exit 1;
fi

DIR="$1"

mkdir -p "$DIR"

cd "$DIR"
mkdir -p bin
mkdir -p dev
mkdir -p etc
mkdir -p home
mkdir -p lib
mkdir -p opt
mkdir -p proc
mkdir -p root
mkdir -p sbin
mkdir -p sys
mkdir -p tmp
mkdir -p var/lib/upm
mkdir -p usr/games
mkdir -p usr/include
mkdir -p usr/share
mkdir -p usr/src
mkdir -p usr/local

ln -sf lib lib64
ln -sf ../lib usr/lib
ln -sf ../lib usr/lib64
ln -sf ../bin usr/bin
ln -sf ../sbin usr/sbin