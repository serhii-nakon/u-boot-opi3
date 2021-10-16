Build on own machine:
1. Please configure LXC on you distributive to be able run it in unpriveleged mode.
2. Run lxcup.sh script
3. It will create u-boot-sunxi-with-spl.bin in root path

How write U-boot image to SD card to first run your system
1. Erase SD card and keep table partition: dd if=/dev/zero of=${card} bs=1k count=1023 seek=1
2. Write image to SD card: dd if=u-boot-sunxi-with-spl.bin of=/dev/sda bs=1024 seek=8

How write U-Boot image to eMMC integrated in SBC 
1. Disable Read-Only protection (after reboot it will with protection): echo 0 > /sys/block/mmcblk1boot0/force_ro && echo 0 > /sys/block/mmcblk1boot1/force_ro
2. Install mmc-utils for you distributive. For Debian/Ubuntu run - sudo apt update && sudo apt install mmc-utils
3. Reconfigure eMMC: mmc bootbus set single_hs x1 x4 /dev/mmcblk1 && mmc bootpart enable 1 1 /dev/mmcblk1
4. Write U-Boot image to eMMC: dd if=u-boot-sunxi-with-spl.bin of=/dev/mmcblk1boot0 bs=4k
5. Reboot your SBC.

Please make sure that your selected correct /dev/mmcblk or /dev/sd devices.

This info taken from:
1. https://linux-sunxi.org/Bootable_eMMC#Installation_from_Linux
2. https://linux-sunxi.org/Bootable_SD_card#Cleaning
