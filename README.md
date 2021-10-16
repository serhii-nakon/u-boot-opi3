Build on own machine:
1. Please configure LXC on you distributive to be able run it in unpriveleged mode.
2. Run lxcup.sh script
3. It will create u-boot-sunxi-with-spl.bin in root path

How write U-boot image to SD card to first run your system
1. Erase SD card and keep table partition
1.1 dd if=/dev/zero of=${card} bs=1k count=1023 seek=1
2. Write image to SD card
2.1 dd if=u-boot-sunxi-with-spl.bin of=/dev/sda bs=1024 seek=8

How write U-Boot image to eMMC integrated in SBC 
1. Disable Read-Only protection (after reboot it will with protection):
1.1 echo 0 > /sys/block/mmcblk1boot0/force_ro
1.2 echo 0 > /sys/block/mmcblk1boot1/force_ro
2. Install mmc-utils for you distributive
2.1 For Debian/Ubuntu run - sudo apt update && sudo apt install mmc-utils
3. Reconfigure eMMC:
3.1 mmc bootbus set single_hs x1 x4 /dev/mmcblk1
3.2 mmc bootpart enable 1 1 /dev/mmcblk1
4. Write U-Boot image to eMMC:
4.1 dd if=u-boot-sunxi-with-spl.bin of=/dev/mmcblk1boot0 bs=4k
5. Reboot your SBC.

Please make sure that your selected correct /dev/mmcblk or /dev/sd devices.

This info taken from:
https://linux-sunxi.org/Bootable_eMMC#Installation_from_Linux
https://linux-sunxi.org/Bootable_SD_card#Cleaning
