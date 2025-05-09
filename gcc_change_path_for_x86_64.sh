#!/bin/bash

cd $1

case "$(uname -m)" in \
	x86_64) \
	sed -i.orig '/m64=/s/lib64/lib/' gcc/config/i386/t-linux64 ;; \
esac