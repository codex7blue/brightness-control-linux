#!/bin/sh

backlight=$(find /sys/class/backlight/* -maxdepth 0 | head -n1)
max=$(cat "$backlight/max_brightness")
step=$(( max / 20 ))

current=$(cat "$backlight/brightness")

case "$1" in
    up)
        new=$(( current + step ))
        [ "$new" -gt "$max" ] && new=$max
        ;;
    down)
        new=$(( current - step ))
        [ "$new" -lt 0 ] && new=0
        ;;
    *)
        echo "Usage: $0 [up|down]"
        exit 1
        ;;
esac

echo "$new" > "$backlight/brightness"
