#!/usr/bin/env bash

ROOTAPP=$(dirname $(realpath -s $0))
cp -v $ROOTAPP/lxc.sample.conf $ROOTAPP/lxc.conf
sed -i "s@<ROOTAPP>@$ROOTAPP@g" $ROOTAPP/lxc.conf
lxc-create -t download -n u-boot -f $ROOTAPP/lxc.conf -- -d debian -r bookworm -a amd64 --no-validate
rm -v $ROOTAPP/lxc.conf
lxc-unpriv-start u-boot
sleep 15
lxc-attach u-boot -- /root/uboot.sh
lxc-stop u-boot
lxc-destroy u-boot
