# Table of Contents

- [Table of Contents](#table-of-contents)
- [Buildroot](#buildroot)
  - [Build](#build)
  - [Copy artifacts in SD card](#copy-artifacts-in-sd-card)
  - [Launch](#launch)
- [Yocto](#yocto)
  - [Build](#build-1)
  - [Copy artifacts in SD card](#copy-artifacts-in-sd-card-1)
  - [Launch](#launch-1)

# Buildroot

## Build

QEMU:
```
cd ~/development/repositories/mastering_embedded_linux_programming/buildroot
make O=./build/qemu qemu_arm_versatile_defconfig
make O=./build/qemu
```

Raspberry Pi 4:
```
cd ~/development/repositories/mastering_embedded_linux_programming/buildroot
make O=./build/rpi raspberrypi4_64_defconfig
make O=./build/rpi
```

BeagleBone Black:
```
cd ~/development/repositories/mastering_embedded_linux_programming/buildroot
make O=./build/bbb beaglebone_defconfig
make O=./build/bbb
```

Notes:
- If you get errors about patcheswile rebuilding, remove (or rename to *.bak) buildroot/package/attr/*.patch.

## Copy artifacts in SD card

Raspberry Pi 4:
```
cd ~/development/repositories/mastering_embedded_linux_programming

# Identify the SD card name, for example, "sdf"
lsblk

# Launch etcher
sudo balena-etcher --no-sandbox
# Click *Flash from file* -> Select buildroot/build/rpi/images/sdcard.img
# Click *Select target* -> /dev/sdf -> Select 1
# Click *Flash*
```

## Launch

QEMU:
```
cd ~/development/repositories/mastering_embedded_linux_programming
qemu-system-arm \
-M versatilepb \
-m 256 \
-kernel buildroot/build/qemu/images/zImage \
-dtb buildroot/build/qemu/images/versatile-pb.dtb \
-drive file=buildroot/build/qemu/images/rootfs.ext2,if=scsi,format=raw \
-append "root=/dev/sda console=ttyAMA0,115200" \
-serial stdio \
-net nic,model=rtl8139 \
-net user
```

Raspberry Pi 4:
- Turn off Raspberry Pi 4.
- Insert SD card.
- Connect USB to serial converter to [serial header pins](https://learn.adafruit.com/adafruits-raspberry-pi-lesson-5-using-a-console-cable/connect-the-lead).
- Follow instructions in [Open serial port](melp_environment_setup.md#open-serial-port).
- Turn on Raspberry Pi 4.
- Linux output should be available in the serial port terminal.

# Yocto

## Build

QEMU:
```
cd ~/development/repositories/mastering_embedded_linux_programming/yocto
source poky/oe-init-build-env build-qemuarm
# Unomment the following line in file yocto/build-qemuarm/conf/local.conf
# MACHINE ?= "qemuarm"
bitbake core-image-minimal
```

Nova:
```
cd ~/development/repositories/mastering_embedded_linux_programming/yocto
source poky/oe-init-build-env build-nova

# Configure layers (already done)
bitbake-layers add-layer ../meta-nova
bitbake-layers show-layers
# Unomment the following line in file yocto/build-nova/conf/local.conf
# MACHINE ?= "beaglebone-yocto"

# Build the image
bitbake nova-image
```

Raspberry Pi 4:
```
# Set the working environment
cd ~/development/repositories/mastering_embedded_linux_programming/yocto
source poky/oe-init-build-env build-rpi

# Configure layers (already done)
bitbake-layers add-layer ../meta-openembedded/meta-oe
bitbake-layers add-layer ../meta-openembedded/meta-python
bitbake-layers add-layer ../meta-openembedded/meta-networking
bitbake-layers add-layer ../meta-openembedded/meta-multimedia
bitbake-layers add-layer ../meta-raspberrypi
bitbake-layers show-layers
# Add the following lines in line in file yocto/build-rpi/conf/local.conf
# MACHINE = "raspberrypi4-64"
# DISTRO = "mackerel"
# PACKAGE_CLASSES ?= "package_ipk"
# EXTRA_IMAGE_FEATURES ?= "debug-tweaks ssh-server-openssh package-management"
# # Package linux-firmware-rpidistro includes some firmware blobs under the Synaptics license
# LICENSE_FLAGS_ACCEPTED += "synaptics-killswitch"

# Create a distro (already done)
bitbake-layers create-layer ../meta-mackerel
bitbake-layers add-layer ../meta-mackerel
bitbake-layers show-layers
# Create file ~/development/repositories/mastering_embedded_linux_programming/yocto/meta-mackerel/conf/distro/
mackerel.conf, and add the following lines in line.
# DISTRO_NAME = "Mackerel (Mackerel Embedded Linux Distro)"
# DISTRO_VERSION = "0.1"

# Build the image
bitbake rpi-test-image
```

## Copy artifacts in SD card

Raspberry Pi 4:
```
cd ~/development/repositories/mastering_embedded_linux_programming

# Identify the SD card name, for example, "sdf"
lsblk

# Extract the compressed image
cp yocto/build-rpi/tmp-glibc/deploy/images/raspberrypi4-64/rpi-test-image-raspberrypi4-64.rootfs.wic.bz2 rpi-test-image.wic.bz2
bunzip2 rpi-test-image.wic.bz2

# Launch etcher
sudo balena-etcher --no-sandbox
# Click *Flash from file* -> Select rpi-test-image.wic
# Click *Select target* -> /dev/sdf -> Select 1
# Click *Flash*

# Close etcher

# Remove the extracted image
rm rpi-test-image.wic
```

## Launch

QEMU:
```
cd ~/development/repositories/mastering_embedded_linux_programming/yocto
source poky/oe-init-build-env build-qemuarm
runqemu qemuarm nographic
```

Raspberry Pi 4:
- Turn off Raspberry Pi 4.
- Insert SD card.
- Turn on Raspberry Pi 4.
- Connect Raspberry Pi 4 ethernet to the LAN.
- Connect thorugh SSH to the Raspberry Pi 4.
```
# Search the IP of the Raspberry Pi 4
sudo arp-scan --interface=eth3 --localnet
# Search a line like: 192.168.1.174   d8:3a:dd:e6:29:86       Raspberry Pi Trading Ltd

# Connect to the Raspberry Pi through SSH
ssh root@192.168.1.174
```
