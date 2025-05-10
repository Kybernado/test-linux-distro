MKDIR = mkdir
CD = cd
SUDO = sudo
CP = cp
RM = rm
CHMOD = chmod
LN = ln
MV = mv

QEMU_DIR = qemu
DOCKER_DIR = docker

BUILD_DIR = build

INITFS_DIR = $(BUILD_DIR)/initfs

USERSPACE_SOURCE_DIR = userspace
USERSPACE_BUILD_DIR = $(BUILD_DIR)/userspace

KERNEL_BUILD_DIR = $(BUILD_DIR)/kernel
KERNEL_SOURCE_DIR = kernel

SINIT_BUILD_DIR = $(USERSPACE_BUILD_DIR)/sinit/build
SINIT_INSTALL_DIR = $(USERSPACE_BUILD_DIR)/sinit/install
SINIT_SOURCE_DIR = $(abspath $(USERSPACE_SOURCE_DIR)/sinit)

GLIBC_BUILD_DIR = $(USERSPACE_BUILD_DIR)/glibc/build
GLIBC_INSTALL_DIR = $(USERSPACE_BUILD_DIR)/glibc/install
GLIBC_SOURCE_DIR = $(abspath $(USERSPACE_SOURCE_DIR)/glibc)

BZIP2_BUILD_DIR = $(USERSPACE_BUILD_DIR)/bzip2/build
BZIP2_INSTALL_DIR = $(USERSPACE_BUILD_DIR)/bzip2/install
BZIP2_SOURCE_DIR = $(abspath $(USERSPACE_SOURCE_DIR)/bzip2)

READLINE_BUILD_DIR = $(USERSPACE_BUILD_DIR)/readline/build
READLINE_INSTALL_DIR = $(USERSPACE_BUILD_DIR)/readline/install
READLINE_SOURCE_DIR = $(abspath $(USERSPACE_SOURCE_DIR)/readline)

ZLIB_BUILD_DIR = $(USERSPACE_BUILD_DIR)/zlib/build
ZLIB_INSTALL_DIR = $(USERSPACE_BUILD_DIR)/zlib/install
ZLIB_SOURCE_DIR = $(abspath $(USERSPACE_SOURCE_DIR)/zlib)

NCURSES_BUILD_DIR = $(USERSPACE_BUILD_DIR)/ncurses/build
NCURSES_INSTALL_DIR = $(USERSPACE_BUILD_DIR)/ncurses/install
NCURSES_SOURCE_DIR = $(abspath $(USERSPACE_SOURCE_DIR)/ncurses)

ATTR_BUILD_DIR = $(USERSPACE_BUILD_DIR)/attr/build
ATTR_INSTALL_DIR = $(USERSPACE_BUILD_DIR)/attr/install
ATTR_SOURCE_DIR = $(abspath $(USERSPACE_SOURCE_DIR)/attr)

ACL_BUILD_DIR = $(USERSPACE_BUILD_DIR)/acl/build
ACL_INSTALL_DIR = $(USERSPACE_BUILD_DIR)/acl/install
ACL_SOURCE_DIR = $(abspath $(USERSPACE_SOURCE_DIR)/acl)

ZSTD_BUILD_DIR = $(USERSPACE_BUILD_DIR)/zstd/build
ZSTD_INSTALL_DIR = $(USERSPACE_BUILD_DIR)/zstd/install
ZSTD_SOURCE_DIR = $(abspath $(USERSPACE_SOURCE_DIR)/zstd)

LIBCAP_BUILD_DIR = $(USERSPACE_BUILD_DIR)/libcap/build
LIBCAP_INSTALL_DIR = $(USERSPACE_BUILD_DIR)/libcap/install
LIBCAP_SOURCE_DIR = $(abspath $(USERSPACE_SOURCE_DIR)/libcap)

BASH_BUILD_DIR = $(USERSPACE_BUILD_DIR)/bash/build
BASH_INSTALL_DIR = $(USERSPACE_BUILD_DIR)/bash/install
BASH_SOURCE_DIR = $(abspath $(USERSPACE_SOURCE_DIR)/bash)

COREUTILS_BUILD_DIR = $(USERSPACE_BUILD_DIR)/coreutils/build
COREUTILS_INSTALL_DIR = $(USERSPACE_BUILD_DIR)/coreutils/install
COREUTILS_SOURCE_DIR = $(abspath $(USERSPACE_SOURCE_DIR)/coreutils)

UTILLINUX_BUILD_DIR = $(USERSPACE_BUILD_DIR)/util-linux/build
UTILLINUX_INSTALL_DIR = $(USERSPACE_BUILD_DIR)/util-linux/install
UTILLINUX_SOURCE_DIR = $(abspath $(USERSPACE_SOURCE_DIR)/util-linux)

GCC_BUILD_DIR = $(USERSPACE_BUILD_DIR)/gcc/build
GCC_INSTALL_DIR = $(USERSPACE_BUILD_DIR)/gcc/install
GCC_SOURCE_DIR = $(abspath $(USERSPACE_SOURCE_DIR)/gcc)

UPM_BUILD_DIR = $(USERSPACE_BUILD_DIR)/upm/build
UPM_INSTALL_DIR = $(USERSPACE_BUILD_DIR)/upm/install
UPM_SOURCE_DIR = $(abspath $(USERSPACE_SOURCE_DIR)/upm)

TESTPROG_BUILD_DIR = $(BUILD_DIR)/testprog/build
TESTPROG_INSTALL_DIR = $(BUILD_DIR)/testprog/install
TESTPROG_SOURCE_DIR = $(abspath testprog)

QEMU_PAIR_DIR = $(BUILD_DIR)/qemu_pair
DOCKER_IMAGE_DIR = $(BUILD_DIR)/docker_image


CREATE_INITFS_SCRIPT = create_initfs.sh
CREATE_DISK_SCRIPT = create_disk.sh
RUN_SYSTEM_SCRIPT = run_system.sh

DISK_IMG_NAME = disk.img

build-kernel:
	$(MKDIR) -p $(KERNEL_BUILD_DIR)
	$(MAKE) -C $(KERNEL_SOURCE_DIR) O=$(abspath $(KERNEL_BUILD_DIR)) defconfig
	$(MAKE) -C $(KERNEL_SOURCE_DIR) O=$(abspath $(KERNEL_BUILD_DIR))

build-userspace:
	# initfs
	$(MKDIR) -p $(INITFS_DIR)
	./create_initfs.sh $(INITFS_DIR)
	
	# env paths setup
	CPATH=$(abspath $(INITFS_DIR)/usr/include) LIBRARY_PATH=$(abspath $(INITFS_DIR)/lib)
	
	# build and install dirs for 3rd party components
	$(MKDIR) -p $(USERSPACE_BUILD_DIR)
	$(MKDIR) -p $(SINIT_BUILD_DIR) $(SINIT_INSTALL_DIR)
	$(MKDIR) -p $(GLIBC_BUILD_DIR) $(GLIBC_INSTALL_DIR)
	$(MKDIR) -p $(BZIP2_BUILD_DIR) $(BZIP2_INSTALL_DIR)
	$(MKDIR) -p $(READLINE_BUILD_DIR) $(READLINE_INSTALL_DIR)
	$(MKDIR) -p $(ZLIB_BUILD_DIR) $(ZLIB_INSTALL_DIR)
	$(MKDIR) -p $(NCURSES_BUILD_DIR) $(NCURSES_INSTALL_DIR)
	$(MKDIR) -p $(ATTR_BUILD_DIR) $(ATTR_INSTALL_DIR)
	$(MKDIR) -p $(ACL_BUILD_DIR) $(ACL_INSTALL_DIR)
	$(MKDIR) -p $(ZSTD_BUILD_DIR) $(ZSTD_INSTALL_DIR)
	$(MKDIR) -p $(LIBCAP_BUILD_DIR) $(LIBCAP_INSTALL_DIR)
	$(MKDIR) -p $(BASH_BUILD_DIR) $(BASH_INSTALL_DIR)
	$(MKDIR) -p $(COREUTILS_BUILD_DIR) $(COREUTILS_INSTALL_DIR)
	$(MKDIR) -p $(UTILLINUX_BUILD_DIR) $(UTILLINUX_INSTALL_DIR)
	$(MKDIR) -p $(GCC_BUILD_DIR) $(GCC_INSTALL_DIR)
	$(MKDIR) -p $(UPM_BUILD_DIR) $(UPM_INSTALL_DIR)
	$(MKDIR) -p $(TESTPROG_BUILD_DIR) $(TESTPROG_INSTALL_DIR)
	
	
	# sinit
	$(CP) -r $(SINIT_SOURCE_DIR)/* $(SINIT_BUILD_DIR)/
	$(MAKE) -C $(SINIT_BUILD_DIR) PREFIX= MANPREFIX=/usr/share
	$(MAKE) -C $(SINIT_BUILD_DIR) install DESTDIR=$(abspath $(SINIT_INSTALL_DIR)) PREFIX= MANPREFIX=/usr/share
	@if [ -d "$(SINIT_INSTALL_DIR)/bin" ]; then \
		rm -rf "$(SINIT_INSTALL_DIR)/sbin"; \
		mv "$(SINIT_INSTALL_DIR)/bin" "$(SINIT_INSTALL_DIR)/sbin"; \
	fi
	@if [ -f "$(SINIT_INSTALL_DIR)/sbin/sinit" ]; then \
		rm -f "$(SINIT_INSTALL_DIR)/sbin/init"; \
		mv "$(SINIT_INSTALL_DIR)/sbin/sinit" "$(SINIT_INSTALL_DIR)/sbin/init"; \
	fi
	$(CP) -r $(SINIT_INSTALL_DIR)/* $(INITFS_DIR)/
	
	# glibc and ld-linux.so
	$(CD) $(GLIBC_BUILD_DIR) && $(GLIBC_SOURCE_DIR)/configure --prefix=/
	$(MAKE) -C $(GLIBC_BUILD_DIR)
	$(MAKE) -C $(GLIBC_BUILD_DIR) install DESTDIR=$(abspath $(GLIBC_INSTALL_DIR))
	$(MKDIR) -p $(GLIBC_INSTALL_DIR)/usr
	if [ -d "$(GLIBC_INSTALL_DIR)/usr/include" ]; then \
		rm -rf "$(GLIBC_INSTALL_DIR)/usr/include"; \
	fi
	$(MV) -f $(GLIBC_INSTALL_DIR)/include $(GLIBC_INSTALL_DIR)/usr/include 
	if [ -d "$(GLIBC_INSTALL_DIR)/usr/libexec" ]; then \
		rm -rf "$(GLIBC_INSTALL_DIR)/usr/libexec"; \
	fi
	$(MV) -f $(GLIBC_INSTALL_DIR)/libexec $(GLIBC_INSTALL_DIR)/usr/libexec
	if [ -d "$(GLIBC_INSTALL_DIR)/usr/share" ]; then \
		rm -rf "$(GLIBC_INSTALL_DIR)/usr/share"; \
	fi
	$(MV) -f $(GLIBC_INSTALL_DIR)/share $(GLIBC_INSTALL_DIR)/usr/share
	$(CP) -r $(GLIBC_INSTALL_DIR)/* $(INITFS_DIR)/
	
	# bzip2
	$(CP) -r $(BZIP2_SOURCE_DIR)/* $(BZIP2_BUILD_DIR)/
	$(MAKE) -C $(BZIP2_BUILD_DIR) -f Makefile-libbz2_so
	$(MAKE) -C $(BZIP2_BUILD_DIR)
	$(MAKE) -C $(BZIP2_BUILD_DIR) install PREFIX=$(abspath $(BZIP2_INSTALL_DIR))
	$(MKDIR) -p $(BZIP2_INSTALL_DIR)/usr
	if [ -d "$(BZIP2_INSTALL_DIR)/usr/man" ]; then \
		rm -rf "$(BZIP2_INSTALL_DIR)/usr/man"; \
	fi
	$(MV) -f $(BZIP2_INSTALL_DIR)/man $(BZIP2_INSTALL_DIR)/usr/man
	if [ -d "$(BZIP2_INSTALL_DIR)/usr/include" ]; then \
		rm -rf "$(BZIP2_INSTALL_DIR)/usr/include"; \
	fi
	$(MV) -f $(BZIP2_INSTALL_DIR)/include $(BZIP2_INSTALL_DIR)/usr/include
	$(CP) $(BZIP2_BUILD_DIR)/libbz2.so.1.0.8 $(BZIP2_INSTALL_DIR)/lib/libbz2.so.1.0.8
	$(CP) $(BZIP2_BUILD_DIR)/libbz2.so.1.0 $(BZIP2_INSTALL_DIR)/lib/libbz2.so.1.0
	$(CP) $(BZIP2_BUILD_DIR)/bzip2-shared $(BZIP2_INSTALL_DIR)/bin/bzip2-shared
	$(CP) -r $(BZIP2_INSTALL_DIR)/* $(INITFS_DIR)/
	
	# readline
	$(CD) $(READLINE_BUILD_DIR) && $(READLINE_SOURCE_DIR)/configure --prefix=/
	$(MAKE) -C $(READLINE_BUILD_DIR)
	$(MAKE) -C $(READLINE_BUILD_DIR) install DESTDIR=$(abspath $(READLINE_INSTALL_DIR))
	$(MKDIR) -p $(READLINE_INSTALL_DIR)/usr
	if [ -d "$(READLINE_INSTALL_DIR)/usr/include" ]; then \
		rm -rf "$(READLINE_INSTALL_DIR)/usr/include"; \
	fi
	$(MV) -f $(READLINE_INSTALL_DIR)/include $(READLINE_INSTALL_DIR)/usr/include 
	if [ -d "$(READLINE_INSTALL_DIR)/usr/share" ]; then \
		rm -rf "$(READLINE_INSTALL_DIR)/usr/share"; \
	fi
	$(MV) -f $(READLINE_INSTALL_DIR)/share $(READLINE_INSTALL_DIR)/usr/share
	$(CP) -r $(READLINE_INSTALL_DIR)/* $(INITFS_DIR)/
	
	# zlib
	$(CD) $(ZLIB_BUILD_DIR) && $(ZLIB_SOURCE_DIR)/configure --prefix=/
	$(MAKE) -C $(ZLIB_BUILD_DIR)
	$(MAKE) -C $(ZLIB_BUILD_DIR) install DESTDIR=$(abspath $(ZLIB_INSTALL_DIR))
	$(MKDIR) -p $(ZLIB_INSTALL_DIR)/usr
	if [ -d "$(ZLIB_INSTALL_DIR)/usr/include" ]; then \
		rm -rf "$(ZLIB_INSTALL_DIR)/usr/include"; \
	fi
	$(MV) -f $(ZLIB_INSTALL_DIR)/include $(ZLIB_INSTALL_DIR)/usr/include 
	if [ -d "$(ZLIB_INSTALL_DIR)/usr/share" ]; then \
		rm -rf "$(ZLIB_INSTALL_DIR)/usr/share"; \
	fi
	$(MV) -f $(ZLIB_INSTALL_DIR)/share $(ZLIB_INSTALL_DIR)/usr/share
	$(CP) -r $(ZLIB_INSTALL_DIR)/* $(INITFS_DIR)/
	
	# ncurses
	$(CD) $(NCURSES_BUILD_DIR) && $(NCURSES_SOURCE_DIR)/configure --prefix=/usr --exec-prefix=/ --without-ada --with-shared --without-debug --enable-widec --with-versioned-syms --with-shlib-version=rel --without-cxx
	$(MAKE) -C $(NCURSES_BUILD_DIR) all
	$(MAKE) -C $(NCURSES_BUILD_DIR) install DESTDIR=$(abspath $(NCURSES_INSTALL_DIR))
	$(CP) -r $(NCURSES_INSTALL_DIR)/* $(INITFS_DIR)/
	
	# attr
	$(CD) $(ATTR_SOURCE_DIR) && ./autogen.sh
	$(CD) $(ATTR_BUILD_DIR) && $(ATTR_SOURCE_DIR)/configure --prefix=/
	$(MAKE) -C $(ATTR_BUILD_DIR)
	$(MAKE) -C $(ATTR_BUILD_DIR) install DESTDIR=$(abspath $(ATTR_INSTALL_DIR))
	$(MKDIR) -p $(ATTR_INSTALL_DIR)/usr
	if [ -d "$(ATTR_INSTALL_DIR)/usr/include" ]; then \
		rm -rf "$(ATTR_INSTALL_DIR)/usr/include"; \
	fi
	$(MV) -f $(ATTR_INSTALL_DIR)/include $(ATTR_INSTALL_DIR)/usr/include
	if [ -d "$(ATTR_INSTALL_DIR)/usr/share" ]; then \
		rm -rf "$(ATTR_INSTALL_DIR)/usr/share"; \
	fi
	$(MV) -f $(ATTR_INSTALL_DIR)/share $(ATTR_INSTALL_DIR)/usr/share
	$(CP) -r $(ATTR_INSTALL_DIR)/* $(INITFS_DIR)/
	
	# acl
	$(CD) $(ACL_SOURCE_DIR) && ./autogen.sh
	$(CD) $(ACL_BUILD_DIR) && $(ACL_SOURCE_DIR)/configure --prefix=/
	$(MAKE) -C $(ACL_BUILD_DIR)
	$(MAKE) -C $(ACL_BUILD_DIR) install DESTDIR=$(abspath $(ACL_INSTALL_DIR))
	$(MKDIR) -p $(ACL_INSTALL_DIR)/usr
	if [ -d "$(ACL_INSTALL_DIR)/usr/include" ]; then \
		rm -rf "$(ACL_INSTALL_DIR)/usr/include"; \
	fi
	$(MV) -f $(ACL_INSTALL_DIR)/include $(ACL_INSTALL_DIR)/usr/include
	if [ -d "$(ACL_INSTALL_DIR)/usr/share" ]; then \
		rm -rf "$(ACL_INSTALL_DIR)/usr/share"; \
	fi
	$(MV) -f $(ACL_INSTALL_DIR)/share $(ACL_INSTALL_DIR)/usr/share
	$(CP) -r $(ACL_INSTALL_DIR)/* $(INITFS_DIR)/
	
	# zstd
	$(CP) -r $(ZSTD_SOURCE_DIR)/* $(ZSTD_BUILD_DIR)
	$(MAKE) -C $(ZSTD_BUILD_DIR)
	$(MAKE) -C $(ZSTD_BUILD_DIR) PREFIX=/ install DESTDIR=$(abspath $(ZSTD_INSTALL_DIR))
	$(MKDIR) -p $(ZSTD_INSTALL_DIR)/usr 
	if [ -d "$(ZSTD_INSTALL_DIR)/usr/include" ]; then \
		rm -rf "$(ZSTD_INSTALL_DIR)/usr/include"; \
	fi
	$(MV) -f $(ZSTD_INSTALL_DIR)/include $(ZSTD_INSTALL_DIR)/usr/include
	if [ -d "$(ZSTD_INSTALL_DIR)/usr/share" ]; then \
		rm -rf "$(ZSTD_INSTALL_DIR)/usr/share"; \
	fi
	$(MV) -f $(ZSTD_INSTALL_DIR)/share $(ZSTD_INSTALL_DIR)/usr/share
	$(CP) -r $(ZSTD_INSTALL_DIR)/* $(INITFS_DIR)/
	
	# libcap
	$(CP) -r $(LIBCAP_SOURCE_DIR)/* $(LIBCAP_BUILD_DIR)/
	$(MAKE) -C $(LIBCAP_BUILD_DIR)
	$(MAKE) -C $(LIBCAP_BUILD_DIR) PREFIX=/usr install DESTDIR=$(abspath $(LIBCAP_INSTALL_DIR))
	if [ -d "$(LIBCAP_INSTALL_DIR)/lib" ]; then \
		rm -rf "$(LIBCAP_INSTALL_DIR)/lib"; \
	fi
	$(MV) -f $(LIBCAP_INSTALL_DIR)/lib64 $(LIBCAP_INSTALL_DIR)/lib
	$(CP) -r $(LIBCAP_INSTALL_DIR)/* $(INITFS_DIR)/
	
	# bash
	$(CD) $(BASH_BUILD_DIR) && $(BASH_SOURCE_DIR)/configure --prefix=/usr --exec-prefix=/ --disable-rpath --enable-readline
	$(MAKE) -C $(BASH_BUILD_DIR)
	$(MAKE) -C $(BASH_BUILD_DIR) install DESTDIR=$(abspath $(BASH_INSTALL_DIR))
	$(CHMOD) +w $(BASH_INSTALL_DIR)/bin/bashbug
	$(CP) -r $(BASH_INSTALL_DIR)/* $(INITFS_DIR)/
	
	# coreutils
	$(CD) $(COREUTILS_SOURCE_DIR) && ./bootstrap
	$(CD) $(COREUTILS_BUILD_DIR) && $(COREUTILS_SOURCE_DIR)/configure --prefix=/
	$(MAKE) -C $(COREUTILS_BUILD_DIR)
	$(MAKE) -C $(COREUTILS_BUILD_DIR) install DESTDIR=$(abspath $(COREUTILS_INSTALL_DIR))
	$(MKDIR) -p $(COREUTILS_INSTALL_DIR)/usr
	if [ -d "$(COREUTILS_INSTALL_DIR)/usr/libexec" ]; then \
		rm -rf "$(COREUTILS_INSTALL_DIR)/usr/libexec"; \
	fi
	$(MV) -f $(COREUTILS_INSTALL_DIR)/libexec $(COREUTILS_INSTALL_DIR)/usr/libexec
	if [ -d "$(COREUTILS_INSTALL_DIR)/usr/share" ]; then \
		rm -rf "$(COREUTILS_INSTALL_DIR)/usr/share"; \
	fi
	$(MV) -f $(COREUTILS_INSTALL_DIR)/share $(COREUTILS_INSTALL_DIR)/usr/share
	$(CP) -r $(COREUTILS_INSTALL_DIR)/* $(INITFS_DIR)/
	
	# util-linux
	$(CD) $(UTILLINUX_SOURCE_DIR) && ./autogen.sh
	$(CD) $(UTILLINUX_BUILD_DIR) && $(UTILLINUX_SOURCE_DIR)/configure --prefix=/ --disable-makeinstall-chown --disable-makeinstall-setuid
	$(MAKE) -C $(UTILLINUX_BUILD_DIR)
	$(MAKE) -C $(UTILLINUX_BUILD_DIR) install DESTDIR=$(abspath $(UTILLINUX_INSTALL_DIR))
	if [ -d "$(UTILLINUX_INSTALL_DIR)/usr/include" ]; then \
		rm -rf "$(UTILLINUX_INSTALL_DIR)/usr/include"; \
	fi
	$(MV) -f $(UTILLINUX_INSTALL_DIR)/include $(UTILLINUX_INSTALL_DIR)/usr/include
	if [ -d "$(UTILLINUX_INSTALL_DIR)/usr/share" ]; then \
		rm -rf "$(UTILLINUX_INSTALL_DIR)/usr/share"; \
	fi
	$(MV) -f $(UTILLINUX_INSTALL_DIR)/share $(UTILLINUX_INSTALL_DIR)/usr/share
	$(CP) -rf $(UTILLINUX_INSTALL_DIR)/usr/lib/* $(UTILLINUX_INSTALL_DIR)/lib/
	$(RM) -rf $(UTILLINUX_INSTALL_DIR)/usr/lib
	$(CP) -r $(UTILLINUX_INSTALL_DIR)/* $(INITFS_DIR)/
	
	# gcc
	./gcc_change_path_for_x86_64.sh $(GCC_SOURCE_DIR)
	$(CD) $(GCC_BUILD_DIR) && $(GCC_SOURCE_DIR)/configure --prefix=/usr --exec-prefix=/ --disable-multilib --with-system-zlib --enable-default-pie --enable-default-ssp --enable-host-pie --disable-fixincludes --enable-languages=c,c++,fortran,go,objc,obj-c++,m2
	$(MAKE) -C $(GCC_BUILD_DIR)
	$(MAKE) -C $(GCC_BUILD_DIR) install DESTDIR=$(abspath $(GCC_INSTALL_DIR))
	$(CP) -r $(GCC_INSTALL_DIR)/* $(INITFS_DIR)/
	
	# upm
	$(CP) -r $(UPM_SOURCE_DIR)/* $(UPM_BUILD_DIR)/
	$(CD) $(UPM_BUILD_DIR) && cargo build --release
	$(CP) $(UPM_BUILD_DIR)/target/release/upm $(INITFS_DIR)/bin
	
	# links and init script
	ln -sf $(abspath $(INITFS_DIR))/bin/bash $(abspath $(INITFS_DIR))/bin/sh
	$(CP) rc.init $(INITFS_DIR)/bin/rc.init
	
	# my testing program
	$(CP) -r $(TESTPROG_SOURCE_DIR)/* $(TESTPROG_BUILD_DIR)/
	$(MAKE) -C $(TESTPROG_BUILD_DIR)
	$(MAKE) -C $(TESTPROG_BUILD_DIR) install DESTDIR=$(abspath $(TESTPROG_INSTALL_DIR))
	$(CP) -r $(TESTPROG_INSTALL_DIR)/* $(INITFS_DIR)/opt
	$(LN) -sf $ ../opt/testprog/prog $(INITFS_DIR)/bin/prog
	
	$(CP) testprog-1.0.0.upkg $(INITFS_DIR)/home/testprog-1.0.0.upkg
	$(CP) testprog-1.2.1.upkg $(INITFS_DIR)/home/testprog-1.2.1.upkg
	
	
build: build-kernel build-userspace

qemu-pair-only:
	$(MKDIR) -p $(QEMU_PAIR_DIR)
	$(CD) $(QEMU_DIR)
	$(SUDO) $(QEMU_DIR)/$(CREATE_DISK_SCRIPT) $(QEMU_PAIR_DIR)/$(DISK_IMG_NAME) $(INITFS_DIR)
	$(CP) $(QEMU_DIR)/$(RUN_SYSTEM_SCRIPT) $(QEMU_PAIR_DIR)/$(RUN_SYSTEM_SCRIPT)
	
docker-image-only:
	$(MKDIR) -p $(DOCKER_IMAGE_DIR)
	$(CP) $(DOCKER_DIR)/Dockerfile $(DOCKER_IMAGE_DIR)/Dockerfile
	$(CP) -r $(INITFS_DIR) $(DOCKER_IMAGE_DIR)/initfs
	
qemu-pair: build
	$(MKDIR) -p $(QEMU_PAIR_DIR)
	$(CD) $(QEMU_DIR)
	$(SUDO) $(QEMU_DIR)/$(CREATE_DISK_SCRIPT) $(QEMU_PAIR_DIR)/$(DISK_IMG_NAME) $(INITFS_DIR)
	$(CP) $(QEMU_DIR)/$(RUN_SYSTEM_SCRIPT) $(QEMU_PAIR_DIR)/$(RUN_SYSTEM_SCRIPT)

docker-image: build-userspace
	$(MKDIR) -p $(DOCKER_IMAGE_DIR)
	$(CP) $(DOCKER_DIR)/Dockerfile $(DOCKER_IMAGE_DIR)/Dockerfile
	$(CP) -r $(INITFS_DIR) $(DOCKER_IMAGE_DIR)/initfs
	
iso:
	@echo "Not yet implemented..."

all: docker-image qemu-pair 
	@echo "Iso target not yet implemented..."

clean:
	$(MAKE) -C $(KERNEL_SOURCE_DIR) clean
	$(RM) -rf $(BUILD_DIR)
	

check test:
	@echo "Not yet implemented..."

help:
	@echo ""
	@echo "Available targets:"
	@echo ""
	@echo "  build              Build the full system (kernel, userspace, and initfs)"
	@echo "  build-kernel       Build only the kernel"
	@echo "  build-userspace    Build userspace components, including glibc and programs"
	@echo "  build-initfs       Create initfs and install userspace into it"
	@echo ""
	@echo "  qemu-pair          Create a disk image and QEMU run script for system emulation"
	@echo "  docker-image       (Not implemented) Build a Docker image containing the system"
	@echo "  iso                (Not implemented) Build a bootable ISO image"
	@echo ""
	@echo "  clean              Remove all build artifacts"
	@echo "  check / test       Placeholder for future tests"
	@echo "  install            Not supported. Use 'qemu-pair', 'docker-image', or 'iso' instead"
	@echo ""
	@echo "Default usage:"
	@echo "  make build         Build everything"
	@echo "  make qemu-pair     Prepare a QEMU disk and launch script"
	@echo ""

install:
	@echo "This target is not supported for this project."
	@echo "Consider using one of these targets:"
	@echo -e "\tqemu-pair"
	@echo -e "\tdocker-image"
	@echo -e "\tiso"