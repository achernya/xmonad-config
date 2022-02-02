xrandr --dpi 144
autorandr --change
xscreensaver -nosplash&
setxkbmap -option ctrl:nocaps
xset r rate 500 30
xsetroot -cursor_name left_ptr
trayer --edge top --align center --SetDockType true --SetPartialStrut true --monitor primary --widthtype request --transparent true --tint 0x0&
nm-applet&
flameshot&

exec bash --login -c "exec ssh-agent xmonad"
