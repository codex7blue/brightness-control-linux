#!/bin/sh

backlight=$(find /sys/class/backlight/* -maxdepth 0 | head -n1)
max=$(cat "$backlight/max_brightness")
step=$(( max / 20 ))  # 5%

current=$(cat "$backlight/brightness")

if [ "$1" = "up" ]; then
    new=$(( current + step ))
    [ "$new" -gt "$max" ] && new=$max
elif [ "$1" = "down" ]; then
    new=$(( current - step ))
    [ "$new" -lt 0 ] && new=0
else
    exit 1
fi

echo "$new" | sudo tee "$backlight/brightness" > /dev/null
