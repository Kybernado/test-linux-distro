# test-linux-distro
This is repository of a minimalistic Linux distribution, as a proof-of-concept of a distribution framework (not any code, just a document of rules) I'm working on for Diploma thesis.

It tries to showcase that a linux distribution can be divided into **system** part and **user space** part (not to be confused with ring 3 on x86 CPUs), without having any additonal overhead or snadbox, like **Flatpak** or **Snap** have.

It does fullfill this requirement by dividing paths of system components and user installed apps.  
System components go to standard FHS defined paths - `/bin`, `/lib`, `/usr/*`, ... and user installed apps go to `/opt/<appname>`, while keeping their non-system dependencies in their directory.

The system consists of apps/libs from these repositories:

| Repository        | Description                                                             |
|-------------------|-------------------------------------------------------------------------|
| `glibc`           | glibc, ld-linux.so, and their dependencies                              |
| `sinit`           | Simple init system for minimalist Linux setups                          |
| `libcap`          | POSIX capabilities library for fine-grained privileges                  |
| `acl`             | Access Control List support for filesystems                             |
| `readline`        | GNU readline library for command-line editing                           |
| `zlib`            | Compression library used for data compression                           |
| `ncurses`         | Terminal handling library for TUIs                                      |
| `attr`            | Utilities for extended file attributes                                  |
| `bzip2`           | Compression program and library that uses Burrows–Wheeler algorithm     |
| `zstd`            | Fast compression algorithm by Facebook                                  |
| `coreutils`       | GNU core command-line utilities (ls, cp, mv, etc.)                      |
| `util-linux`      | Essential system utilities (mount, fdisk, etc.)                         |
| `gcc`             | GNU Compiler Collection                                                 |
| `bash`            | GNU Bourne Again Shell (default Linux shell)                            |

It is not yet specified which of these components make the base system contract, and which do not, and are here only for reference purpose only, so the system boots, and can be demonstrated as is.

<u>Note: the linker here is not modified yet, and this system acts like a bootstrap for next work.</u>

---

## Usage

### Core Build Targets

| Target            | Description                                                             |
|-------------------|-------------------------------------------------------------------------|
| `make build`      | Build the full system (kernel, userspace, and initfs)                   |
| `make build-kernel`    | Build only the kernel                                                   |
| `make build-userspace` | Build userspace components, including glibc and programs                |
| `make build-initfs`    | Create initfs and install userspace into it                             |

---

### Deployment Targets

| Target             | Description                                                             |
|--------------------|-------------------------------------------------------------------------|
| `make qemu-pair`   | Create a disk image and QEMU run script for system emulation            |
| `make docker-image`| Build a Docker image containing the system                              |
| `make iso`         | _(Not implemented)_ Build a bootable ISO image                          |

---

### Maintenance Targets

| Target         | Description                                                    |
|----------------|----------------------------------------------------------------|
| `make clean`   | Remove all build artifacts                                     |
| `make check`   | Placeholder for future tests                                   |
| `make test`    | Alias for `check`                                              |
| `make install` | Not supported — use `qemu-pair`, `docker-image`, or `iso` instead |

---

### Examples

#### Build the full system
make build

#### Generate a disk image and run script for QEMU
make qemu-pair

#### Run distro in QEMU
build/qemu_pair/run_system.sh

#### Run distro in Docker
cd build/docker  
docker-build -t test-linux-distro .  
docker run -it [--rm] test-linux-distro /bin/bash


---

## Build Dependencies

| Package(s)                       | Description                                                                 |
|----------------------------------|-----------------------------------------------------------------------------|
| **gcc**                          | GNU Compiler Collection                                                     |
| **make**                         | Build automation tool                                                       |
| **binutils**                     | Collection of binary tools                                                  |
| **bison**                        | Parser generator                                                            |
| **flex**                         | Lexical analyzer generator                                                  |
| **perl**                         | Required for kernel builds                                                  |
| **bash**                         | Bourne Again SHell                                                          |
| **pkg-config**                   | Manage compile and link flags for libraries                                 |
| **gettext**                      | Internationalization and localization                                       |
| **autoconf**, **automake**, **libtool** | GNU build system tools                                               |
| **bc**                           | Arbitrary precision calculator language (required for kernel builds)        |
| **pahole**                       | DWARF debugging information analyzer (optional for kernel builds)           |
| **util-linux**                   | Collection of essential utilities                                           |
| **coreutils**                    | Basic file, shell, and text manipulation utilities                          |
| **gnulib**                       | GNU portability library (used by several GNU projects)                      |
| **cargo**                        | Rust's build system                                                         |


### Debian / Ubuntu / Mint
```
sudo apt update
sudo apt install -y \
  build-essential bison flex \
  perl bash pkg-config \
  gettext autoconf automake \
  libtool bc dwarves \
  util-linux coreutils gnulib rustup cargo
```

### Arch Linux / Manjaro / Artix Linux
```
sudo pacman -Syu --needed \
  base-devel bison flex \
  perl bash pkgconf \
  gettext autoconf automake \
  libtool bc dwarves \
  util-linux coreutils gnulib rustup cargo
```

### Fedora / RHEL / CentOS / Rocky / AlmaLinux
```
sudo dnf install -y \
  gcc gcc-c++ make \
  binutils bison flex \
  perl bash pkgconf \
  pkgconf-pkg-config gettext autoconf \
  automake libtool bc \
  dwarves util-linux coreutils \
  gnulib rustup cargo
```
