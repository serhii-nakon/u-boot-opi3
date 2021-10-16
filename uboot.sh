#!/usr/bin/env bash

apt update
apt install gcc-aarch64-linux-gnu bison flex swig python-dev build-essential device-tree-compiler python3 python3-dev libssl-dev git bc python3-setuptools sed gcc-or1k-elf -y

cd /root
git clone --single-branch --branch v2021.10 https://github.com/u-boot/u-boot.git
git clone --single-branch --branch v2.5 https://github.com/ARM-software/arm-trusted-firmware.git
git clone --single-branch --branch v0.4 https://github.com/crust-firmware/crust.git

cd /root/arm-trusted-firmware

make -j 16 CROSS_COMPILE=aarch64-linux-gnu- PLAT=sun50i_h6 bl31

cd /root/crust

make -j 16 CROSS_COMPILE=aarch64-linux-gnu- orangepi_3_defconfig
make -j 16 CROSS_COMPILE=or1k-elf- scp

cd /root/u-boot

echo CONFIG_SUPPORT_EMMC_BOOT=y >> /root/u-boot/configs/orangepi_3_defconfig
make -j 16 CROSS_COMPILE=aarch64-linux-gnu- BL31=/root/arm-trusted-firmware/build/sun50i_h6/release/bl31.bin SCP=/root/crust/build/scp/scp.bin orangepi_3_defconfig
make -j 16 CROSS_COMPILE=aarch64-linux-gnu- BL31=/root/arm-trusted-firmware/build/sun50i_h6/release/bl31.bin SCP=/root/crust/build/scp/scp.bin
cp -v /root/u-boot/u-boot-sunxi-with-spl.bin /root
rm -rf /root/u-boot /root/crust /root/arm-trusted-firmware