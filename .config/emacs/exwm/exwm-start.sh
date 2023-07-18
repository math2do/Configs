#!/bin/sh

# Run the screen compositor
compton &

# Enable screen locking on suspend
xss-lock -- slock &

# Fire it up
/snap/emacs/2031/usr/bin/emacs -mm --debug-init -l ~/.config/emacs/desktop.el
