#!/bin/bash

###############################################################################
# To all DEV around the world :)                                              #
# to build this kernel you need to be ROOT and to have bash as script loader  #
# do this:                                                                    #
# cd /bin                                                                     #
# rm -f sh                                                                    #
# ln -s bash sh                                                               #
# now go back to kernel folder and run:                                       # 
#                                                                               #
# sh clean_kernel.sh                                                          #
#                                                                             #
# Now you can build my kernel.                                                #
# using bash will make your life easy. so it's best that way.                 #
# Have fun and update me if something nice can be added to my source.         #
###############################################################################

# Time of build startup
res1=$(date +%s.%N)

echo "${bldcya}***** Setting up Environment *****${txtrst}";

. ./env_setup.sh ${1} || exit 1;

if [ ! -f $KERNELDIR/.config ]; then
        echo "${bldcya}***** Writing Config *****${txtrst}";
        cp $KERNELDIR/arch/arm/configs/$KERNEL_CONFIG .config;
        make $KERNEL_CONFIG;
fi;

. $KERNELDIR/.config

# remove previous zImage files
if [ -e $KERNELDIR/zImage ]; then
        rm $KERNELDIR/zImage;
        rm $KERNELDIR/out/kernel/zImage;
fi;
if [ -e $KERNELDIR/arch/arm/boot/zImage ]; then
        rm $KERNELDIR/arch/arm/boot/zImage;
fi;

# remove previous initramfs files
rm -rf $KERNELDIR/out/system/lib/modules >> /dev/null;
rm -rf $KERNELDIR/out/tmp_modules >> /dev/null;
rm -rf $KERNELDIR/out/temp >> /dev/null;

# make zImage
echo "${bldcya}***** Compiling kernel *****${txtrst}"
if [ $USER != "root" ]; then
        make -j$NUMBEROFCPUS CONFIG_NO_ERROR_ON_MISMATCH=y zImage-dtb
else
        nice -n -15 make -j$NUMBEROFCPUS CONFIG_NO_ERROR_ON_MISMATCH=y zImage-dtb
fi;

if [ -e $KERNELDIR/arch/arm/boot/zImage ]; then
        echo "${bldcya}***** Final Touch for Kernel *****${txtrst}"
        cp $KERNELDIR/arch/arm/boot/zImage-dtb $KERNELDIR/out/kernel/zImage;
        stat $KERNELDIR/out/kernel/zImage || exit 1;

        echo "--- Creating boot.img ---"
        # copy all needed to out kernel folder
        rm $KERNELDIR/out/next-uni-* >> /dev/null;
        cd $KERNELDIR/out/
        zip -r next-uni-`date +"[%m-%d]-[%H-%M]"`.zip .
        echo "${bldcya}***** Ready to Roar *****${txtrst}";
        # finished? get elapsed time
        res2=$(date +%s.%N)
        echo "${bldgrn}Total time elapsed: ${txtrst}${grn}$(echo "($res2 - $res1) / 60"|bc ) minutes ($(echo "$res2 - $res1"|bc ) seconds) ${txtrst}";        
        exit 0;
else
        echo "${bldred}Kernel STUCK in BUILD!${txtrst}"
fi;
