#!/bin/bash

# storageinfo.sh
# Copyright 2024 Charles McColm
# chaslinux@gmail.com
# Licensed under GPL v3

# The purpose of this script is to create a small information sheet about hard drives or nvme drives
# in order to provide information for someone who might buy a drive from our refurbishing project.
# Our goal is to give buyers information about drives so they can make a better educated decision about
# whether the drive will be acceptable for their use case.

# Update the software index for the computer
sudo apt update && sudo apt -y upgrade

# Install the software necessary for drive detection & LaTeX page creation
sudo apt -y install smartmontools # for hard drives
sudo apt -y install texlive-latex-base # to make pdfs
sudo apt -y install texlive-extra-utils # allow cropping of pdf


# Variable declarattions
SDDRIVE=$(ls -1 /dev/sd?)
SDFAMILY=$(sudo smartctl -d ata -a -i "$SDDRIVE" | grep "Model Family")
SDSERIAL=$(sudo smartctl -a $SDDRIVE | grep "Serial Number:" | cut -c 20- )
SDMODEL=$(sudo smartctl -a $SDDRIVE | grep "Model Number:" | cut -c 20- )
SDSIZE=$(sudo smartctl -a $SDDRIVE | grep "Namespace 1 Size/Capacity:" | cut -c 28- )
SDPOWERON=$(sudo smartctl -a $SDDRIVE | grep "Power On Hours:" | cut -c 20- )
NVDRIVE=$(ls -1 /dev/nvme?)
NVSERIAL=$(sudo smartctl -a $NVDRIVE | grep "Serial Number:" | cut -c 20- )
NVMODEL=$(sudo smartctl -a $NVDRIVE | grep "Model Number:" | cut -c 20- )
NVSIZE=$(sudo smartctl -a $NVDRIVE | grep "Namespace 1 Size/Capacity:" | cut -c 28- )
NVPOWERON=$(sudo smartctl -a $NVDRIVE | grep "Power On Hours:" | cut -c 20- )

# if the storage.tex file exists on the user's desktop, tell them to delete it first
if [ -f /home/"$USER"/Desktop/storageinfo.tex ]; then
{
	echo "storageinfo.tex exists, not writing anything, please delete the file from the desktop"
	echo "and re-run the script."
}
fi

# create the storage.tex file does not exist
if [ ! -f /home/"$USER"/Desktop/storageinfo.tex ]; then
{
	# Hard Drive info
	if sudo lshw -short | grep -m1 sda; then
	{
		echo -e "Model: \t\t"  $SDMODEL >> /home/"$USER"/Desktop/storageinfo.tex
		echo -e "Serial No.: \t" $SDSERIAL >> /home/"$USER"/Desktop/storageinfo.tex
		echo -e "Size: \t\t" $SDSIZE >> /home/"$USER"/Desktop/storageinfo.tex
		echo -e "Hours: \t\t" $SDPOWERON >> /home/"$USER"/Desktop/storageinfo.tex
	}
	fi

	# NVMe Drive info
	if sudo lshw -short | grep -m1 nvme; then
	{
		echo -e "Model: \t\t"  $NVMODEL >> /home/"$USER"/Desktop/storageinfo.tex
		echo -e "Serial No.: \t" $NVSERIAL >> /home/"$USER"/Desktop/storageinfo.tex
		echo -e "Size: \t\t" $NVSIZE >> /home/"$USER"/Desktop/storageinfo.tex
		echo -e "Hours: \t\t" $NVPOWERON >> /home/"$USER"/Desktop/storageinfo.tex
	}
	fi

} 
fi