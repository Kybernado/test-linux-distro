# test-linux-distro
This is repository of a minimalistic Linux distribution, as a proof-of-concept of a distribution framework (not any code, just a document of rules) I'm working on for Bachelor thesis.

It tries to showcase that a linux distribution can be divided into **system** part and **user space** part (not to be confused with ring 3 on x86 CPUs), without having any additonal overhead or snadbox, like **Flatpak** or **Snap** have.

It does fullfill this requirement by dividing paths of system components and user installed apps, and having modified `ld-linux.so` linker so it searches also origin path of executed binary.  
System components go to standard FHS defined paths - `/bin`, `/lib`, `/usr/*`, ... and user installed apps go to `/opt/<appname>`, while keeping their non-system dependencies in their directory.  

The system consists of apps/libs from these repositories:

| Repository        | Description                                                             |
|-------------------|-------------------------------------------------------------------------|
| `glibc`           | glibc, ld-linux.so, and their dependencies                              |
| `coreutils`       | core GNU utilities for UNIX-like systems - grep, more, ls...            |



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
| `make docker-image`| Build a Docker image containing the system          |
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

#### Run distro in qemu
build/qemu_pair/run_system.sh
