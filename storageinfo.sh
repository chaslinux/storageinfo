#!/bin/bash

# storageinfo.sh
# Copyright 2024 Charles McColm
# chaslinux@gmail.com
# Licensed under GPL v3

# The purpose of this script is to create a small information sheet about hard drives or nvme drives
# in order to provide information for someone who might buy a drive from our refurbishing project.
# Our goal is to give buyers information about drives so they can make a better educated decision about
# whether the drive will be acceptable for their use case.

# Hard Drive info
if lshw -short | grep -m1 sd; then
{
	SDDRIVE=$(ls -1 /dev/sd?)
	SDSERIAL=$(sudo smartctl -a $SDDRIVE | grep "Serial Number:" | cut -c 20- )
	SDMODEL=$(sudo smartctl -a $SDDRIVE | grep "Model Number:" | cut -c 20- )
	SDSIZE=$(sudo smartctl -a $SDDRIVE | grep "Namespace 1 Size/Capacity:" | cut -c 28- )
	SDPOWERON=$(sudo smartctl -a $SDDRIVE | grep "Power On Hours:" | cut -c 20- )
	echo -e "Model: \t\t"  $SDMODEL
	echo -e "Serial No.: \t" $SDSERIAL
	echo -e "Size: \t\t" $SDSIZE
	echo -e "Hours: \t\t" $SDPOWERON
}
}
fi

# NVMe Drive info
if lshw -short | grep -m1 nvme; then
{
	NVDRIVE=$(ls -1 /dev/nvme?)
	NVSERIAL=$(sudo smartctl -a $NVDRIVE | grep "Serial Number:" | cut -c 20- )
	NVMODEL=$(sudo smartctl -a $NVDRIVE | grep "Model Number:" | cut -c 20- )
	NVSIZE=$(sudo smartctl -a $NVDRIVE | grep "Namespace 1 Size/Capacity:" | cut -c 28- )
	NVPOWERON=$(sudo smartctl -a $NVDRIVE | grep "Power On Hours:" | cut -c 20- )
	echo -e "Model: \t\t"  $NVMODEL
	echo -e "Serial No.: \t" $NVSERIAL
	echo -e "Size: \t\t" $NVSIZE
	echo -e "Hours: \t\t" $NVPOWERON
}
fi