#!/usr/bin/env bash

set -e

apt update
apt install gcc-aarch64-linux-gnu bison flex swig python2-dev build-essential device-tree-compiler python3 python3-dev libssl-dev git bc python3-setuptools sed gcc-or1k-elf -y

cd /root
git clone --single-branch --branch v2022.07 https://github.com/u-boot/u-boot.git
git clone --single-branch --branch v2.7 https://github.com/ARM-software/arm-trusted-firmware.git
git clone --single-branch --branch v0.5 https://github.com/crust-firmware/crust.git

cd /root/arm-trusted-firmware
export LDFLAGS="--no-warn-rwx-segments"
make -j 16 CROSS_COMPILE=aarch64-linux-gnu- PLAT=sun50i_h6 SUNXI_SETUP_REGULATORS=0 bl31

cd /root/crust
patch -p1 < /root/patches/0001-add_ability_set_ldflags.patch
export LDFLAGS="-Wl,--no-warn-rwx-segments"
make -j 16 CROSS_COMPILE=or1k-elf- orangepi_3_defconfig
make -j 16 CROSS_COMPILE=or1k-elf- scp

cd /root/u-boot

echo CONFIG_SUPPORT_EMMC_BOOT=y >> /root/u-boot/configs/orangepi_3_defconfig
make -j 16 CROSS_COMPILE=aarch64-linux-gnu- BL31=/root/arm-trusted-firmware/build/sun50i_h6/release/bl31.bin SCP=/root/crust/build/scp/scp.bin orangepi_3_defconfig
make -j 16 CROSS_COMPILE=aarch64-linux-gnu- BL31=/root/arm-trusted-firmware/build/sun50i_h6/release/bl31.bin SCP=/root/crust/build/scp/scp.bin
cp -v /root/u-boot/u-boot-sunxi-with-spl.bin /root
rm -rf /root/u-boot /root/crust /root/arm-trusted-firmware
