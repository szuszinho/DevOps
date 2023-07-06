#!/usr/bin/env bash

. vars.sh
wget $url$image_name
mv $image_name image.qcow2
qemu-img resize image.qcow2 24G
qm create 999 --cores 1 --localtime true --memory 1024 --net0 virtio,bridge=vmbr0 --ostype l26 --name ubuntu-cloud --serial0 socket --vga serial0
qm importdisk 999 image.qcow2 $storage
qm set 999 --scsihw virtio-scsi-pci --scsi0 $storage:vm-999-disk-0,size=24G,ssd=1
qm set 999 --ide2 $storage:cloudinit
qm set 999 --boot order=scsi0
qm template 999
echo "Template ready!"
rm image.qcow2