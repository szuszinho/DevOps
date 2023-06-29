#Create VM template from ubuntu cloud image
wget https://cloud-images.ubuntu.com/minimal/releases/jammy/release/ubuntu-22.04-minimal-cloudimg-amd64.img
mv ubuntu-22.04-minimal-cloudimg-amd64.img ubuntu-22.04.qcow2
qemu-img resize ubuntu-22.04.qcow2 24G
qm create 999 --agent 1 --cores 1 --localtime true --memory 1024 --net0 virtio,bridge=vmbr0 --ipconfig0=dhcp --ostype l26 --name ubuntu-cloud --serial0 socket --vga serial0
qm importdisk 999 ubuntu-22.04.qcow2 local-lvm
qm set 999 --scsihw virtio-scsi-single --scsi0 local-lvm:vm-999-disk-0,discard=on,iothread=1,size=24G,ssd=1
qm set 999 --ide0 local-lvm:cloudinit
qm set 999 --boot order=scsi0
qm template 999
rm buntu-22.04.qcow2
