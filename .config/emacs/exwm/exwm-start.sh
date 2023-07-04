#!/bin/sh

# Run the screen compositor
compton &

# Enable screen locking on suspend
xss-lock -- slock &

# Fire it up
emacs -mm --debug-init -l ~/.config/emacs/desktop.el
