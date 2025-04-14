#!/bin/sh

libinput debug-events --device /dev/input/event4 | while read -r line; do
    case "$line" in
        *"KEY_BRIGHTNESSUP (225) pressed"*)
            /usr/local/bin/brightness.sh up
            ;;
        *"KEY_BRIGHTNESSDOWN (224) pressed"*)
            /usr/local/bin/brightness.sh down
            ;;
    esac
done
