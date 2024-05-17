#!/bin/bash

# storageinfo.sh
# Copyright 2024 Charles McColm
# chaslinux@gmail.com
# Licensed under GPL v3

# The purpose of this script is to create a small information sheet about hard drives 
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
SDSERIAL=$(sudo smartctl -a $SDDRIVE | grep "Serial Number" | cut -c 19- )
SDMODEL=$(sudo smartctl -a $SDDRIVE | grep "Device Model" | cut -c 19- )
SDSIZE=$(sudo smartctl -a $SDDRIVE | grep "User Capacity:" | cut -c 19- )
SDPOWERON=$(sudo smartctl -a $SDDRIVE | grep "Power_On_Hours" | cut -c 88- )

echo -e "Brand: \t\t"  $SDFAMILY >> /home/"$USER"/Desktop/storageinfo.tex
echo -e "Model: \t\t" $SDMODEL >> /home/"$USER"/Desktop/storageinfo.tex
echo -e "Serial No.: \t" $SDSERIAL >> /home/"$USER"/Desktop/storageinfo.tex
echo -e "Size: \t\t" $SDSIZE >> /home/"$USER"/Desktop/storageinfo.tex
echo -e "Hours On: \t\t" $SDPOWERON >> /home/"$USER"/Desktop/storageinfo.tex
