#!/bin/sh
/usr/bin/stalonetray -bg '#000000' -i 8 -geometry 3x1+670+0 --kludges=force_icons_size &
/usr/bin/nm-applet &
/usr/bin/krb5-auth-dialog &

/usr/libexec/gnome-settings-daemon &
/usr/bin/gnome-screensaver &

exec xmonad
