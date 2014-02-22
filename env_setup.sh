#!/bin/bash

# location
if [ "${1}" != "" ]; then
	export KERNELDIR=`readlink -f ${1}`;
else
	export KERNELDIR=`readlink -f .`;
fi;

export PARENT_DIR=`readlink -f ${KERNELDIR}/..`;
export INITRAMFS_SOURCE=`readlink -f ${KERNELDIR}/../ramdisk`;
export INITRAMFS_TMP=${KERNELDIR}/tmp/initramfs_source;

# check if parallel installed, if not install
if [ ! -e /usr/bin/parallel ]; then
	echo "You must install 'parallel' by this script to continue.";
	sudo dpkg -i ${KERNELDIR}/utilities/parallel_20120422-1_all.deb
fi

# check if ccache installed, if not install
if [ ! -e /usr/bin/ccache ]; then
	echo "You must install 'ccache' to continue.";
	sudo apt-get install ccache
fi

# kernel
export ARCH=arm;
export SUB_ARCH=arm;
export KERNEL_CONFIG="aux_next_defconfig";

# build script
export USER=`whoami`;
export TMPFILE=`mktemp -t`;
export KBUILD_BUILD_USER="aux";
export KBUILD_BUILD_HOST="cm.webcs.de";

# system compiler
export CROSS_COMPILE=$PARENT_DIR/toolchain-linaro-4.7.4-A15/bin/arm-cortex_a15-linux-gnueabihf-;
# export CROSS_COMPILE=$PARENT_DIR/linaro-toolchain-4.7-2013.12/bin/arm-eabi-;
# export CROSS_COMPILE=$PARENT_DIR/arm-eabi-4.8/bin/arm-eabi-;
# export CROSS_COMPILE=$PARENT_DIR/arm-eabi-4.7/bin/arm-eabi-;

export NUMBEROFCPUS=`grep 'processor' /proc/cpuinfo | wc -l`;

# Colorize and add text parameters
export red=$(tput setaf 1)             #  red
export grn=$(tput setaf 2)             #  green
export blu=$(tput setaf 4)             #  blue
export cya=$(tput setaf 6)             #  cyan
export txtbld=$(tput bold)             #  Bold
export bldred=${txtbld}$(tput setaf 1) #  red
export bldgrn=${txtbld}$(tput setaf 2) #  green
export bldblu=${txtbld}$(tput setaf 4) #  blue
export bldcya=${txtbld}$(tput setaf 6) #  cyan
export txtrst=$(tput sgr0)             #  Reset

