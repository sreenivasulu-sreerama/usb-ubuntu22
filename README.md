# usb-ubuntu20
Prepare a bootable USB stick from ubuntu server 22 ISO image

This script is used to prepare a USB stick with bootable
Ubuntu 22.4 LTS image. The bootable disk is prepared from Ubuntu
server install image. The host machine typically is a CentOS 7
system and is tested with a CentOS 7.6 host.

The script is tested with Ubuntu server 22.04 version downloaded
from (the current subrelease could be different):\
    http://releases.ubuntu.com/jammy/ubuntu-22.04.3-live-server-amd64.iso

This script:
- Can be used to bake directly attached disk like a USB stick.
- Can also be used to generate image suitable for running in the VM.
- Prepares disk compatible with legacy BIOS and does not support UEFI only boot.
- Sets up 'root' without any password and no default user is created.
- Needs network access as ubuntu repo on internet is included in sources list.

## GRUB installation:
During installing the user will be prompted to select the disk to install
GRUB to. Don't select any drive and exit GRUB setup without installation. 
The GRUB bootloader will be setup by the script later without needing any
user prompt. Incorrectly selecting disk when prompted,
may result in GRUB of the build system getting updated
running the risk of the host system becoming non-bootable.

## Usage:
`./ubuntu22-iso-to-disk [--help|--size-gb <size-gb>] [path-to-ubuntu22-iso] [target-device OR disk-image-filename]`

- Default disk imaze size is 8GB (valid range: 8-200GB)
- Target device of type `/dev/xxx` is considered as physically attached disk

