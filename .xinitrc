#!/bin/sh

#export _JAVA_OPTIONS="-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel"
#export _JAVA_AWT_WM_NONREPARENTING=1
#export MATLAB_JAVA=/usr/lib/jvm/java-7-openjdk/jre
#export AWT_TOOLKIT=MToolkit

rfkill block bluetooth

xcompmgr -fF &
#xset r rate 250 30
xset +fp /usr/share/fonts/local/
xrdb -load ~/.Xresources &
xmodmap -e 'remove Lock = Caps_Lock' 
xmodmap -e 'keysym Caps_Lock = Control_L'
xmodmap -e 'add Control = Control_L'
xsetroot -cursor_name left_ptr &
wallpaper.sh &
urxvtd -q -o -f &

#mpd ~/.mpd/mpd.conf

#trayer --edge top --align right --SetDockType true --SetPartialStrut false \
#       --expand true --widthtype request --transparent true --alpha 255 \
#       --tint 0x0 --height 17&

#unclutter &

#exec ck-launch-session dbus-launch --exit-with-session xmonad & wmpid=$!

xrandr --output DP1 --auto --left-of LVDS1

exec xmonad
sleep 1

 #chromium&
 #pidgin&
#volwheel&
 #thunderbird&
#trayfreq &
 #/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
#nm-applet &
 #/usr/lib/notification-daemon-1.0/notification-daemon &

#wait $wmpid

