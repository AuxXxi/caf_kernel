#!/sbin/sh
#

#remove the binaries as they are no longer needed. (kernel handled)
if [ -e /system/bin/mpdecision ] ; then
	busybox mv /system/bin/mpdecision /system/bin/mpdecision_bck
fi
if [ -e /system/bin/thermal-engine-hh ] ; then
	busybox mv /system/bin/thermal-engine-hh /system/bin/thermal-engine-hh_bck
fi

return $?
