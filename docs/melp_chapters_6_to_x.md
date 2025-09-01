# Table of Contents

- [Table of Contents](#table-of-contents)
- [Buildroot](#buildroot)
  - [Build](#build)
  - [Copy artifacts in SD card](#copy-artifacts-in-sd-card)
  - [Launch](#launch)
- [Yocto](#yocto)
  - [Build](#build-1)
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
bitbake-layers add-layer ../meta-nova
bitbake-layers show-layers
# Unomment the following line in file yocto/build-nova/conf/local.conf
# MACHINE ?= "beaglebone-yocto"
bitbake nova-image
```

## Launch

QEMU:
```
cd ~/development/repositories/mastering_embedded_linux_programming/yocto
source poky/oe-init-build-env build-qemuarm
runqemu qemuarm nographic
```
