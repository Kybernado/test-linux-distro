MKDIR = mkdir
CD = cd
SUDO = sudo
CP = cp
RM = rm

BUILD_FOLDER = build
USERSPACE_FOLDER = userspace
PROGS_FOLDER = progs
LIBS_FOLDER = libs
QEMU_FOLDER = qemu
QEMU_PAIR_FOLDER = qemu_pair
KERNEL_FOLDER = kernel
GLIBC_FOLDER = glibc
INITFS_FOLDER = initfs

CREATE_INITFS_SCRIPT = create_initfs.sh
CREATE_DISK_SCRIPT = create_disk.sh
RUN_SYSTEM_SCRIPT = run_system.sh

DISK_IMG_NAME = disk.img

build-kernel:
	$(MKDIR) -p $(BUILD_FOLDER)/$(KERNEL_FOLDER)
	$(MAKE) -C $(KERNEL_FOLDER) O=$(abspath build/kernel) defconfig
	$(MAKE) -C $(KERNEL_FOLDER) O=$(abspath build/kernel)

build-userspace:
	$(MKDIR) -p $(BUILD_FOLDER)/$(INITFS_FOLDER)
	$(MKDIR) -p $(BUILD_FOLDER)/$(USERSPACE_FOLDER)/$(PROGS_FOLDER) $(BUILD_FOLDER)/$(USERSPACE_FOLDER)/$(LIBS_FOLDER)
	$(MKDIR) -p $(BUILD_FOLDER)/$(USERSPACE_FOLDER)/$(GLIBC_FOLDER)
	
	$(CD) $(BUILD_FOLDER)/$(USERSPACE_FOLDER)/$(GLIBC_FOLDER) && ../../../$(GLIBC_FOLDER)/configure --prefix=/usr --enable-debug
	$(MAKE) -C $(BUILD_FOLDER)/$(USERSPACE_FOLDER)/$(GLIBC_FOLDER)

build-initfs: build-userspace
	./$(CREATE_INITFS_SCRIPT) $(BUILD_FOLDER)/$(INITFS_FOLDER)
	$(MAKE) -C $(BUILD_FOLDER)/$(USERSPACE_FOLDER)/$(GLIBC_FOLDER) install DESTDIR=$(abspath build/initfs)
	

build: build-kernel build-userspace build-initfs
	
qemu-pair: build
	$(MKDIR) -p $(BUILD_FOLDER)/$(QEMU_PAIR_FOLDER)
	$(CD) $(QEMU_FOLDER)
	$(SUDO) $(QEMU_FOLDER)/$(CREATE_DISK_SCRIPT) $(BUILD_FOLDER)/$(QEMU_PAIR_FOLDER)/$(DISK_IMG_NAME) $(BUILD_FOLDER)/$(INITFS_FOLDER)
	$(CP) $(QEMU_FOLDER)/$(RUN_SYSTEM_SCRIPT) $(BUILD_FOLDER)/$(QEMU_PAIR_FOLDER)/$(RUN_SYSTEM_SCRIPT)

docker-image: build
	$(MKDIR) -p $(BUILD_FOLDER)/docker_image
	$(CP) docker/Dockerfile $(BUILD_FOLDER)/docker_image/Dockerfile
	$(CP) -r $(BUILD_FOLDER)/$(INITFS_FOLDER) $(BUILD_FOLDER)/docker_image/$(INITFS_FOLDER)
	
iso:
	@echo "Not yet implemented..."

all:
	@echo "Not yet implemented..."

clean:
	$(MAKE) -C $(KERNEL_FOLDER) clean
	$(RM) -rf $(BUILD_FOLDER)
	

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