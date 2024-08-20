if [ "$(getprop ro.boot.ssr.restart.level)" != "" ]
then
    setprop persist.vendor.ssr.restart_level "$(getprop ro.boot.ssr.restart.level)"
else
    setprop persist.vendor.ssr.restart_level "ALL_DISABLE"
fi
setprop persist.vendor.ssr.enable_ramdumps "0"