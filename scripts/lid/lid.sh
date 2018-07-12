grep -q close /proc/acpi/button/lid/*/state
if [ $? = 0 ]; then
    rfkill block wlan
    echo close>>/tmp/screen.lid
fi
grep -q open /proc/acpi/button/lid/*/state
if [ $? = 0 ]; then
    rfkill unblock wlan
    echo open>>/tmp/screen.lid
fi
