#!/bin/sh

# Path ke brightness di sistem
BRIGHTNESS_PATH="/sys/class/backlight/intel_backlight"
BRIGHTNESS_FILE="$BRIGHTNESS_PATH/brightness"
MAX_BRIGHTNESS_FILE="$BRIGHTNESS_PATH/max_brightness"
STEP=$(( $(cat "$MAX_BRIGHTNESS_FILE") / 20 ))  # 5% dari max brightness

# Fungsi mendapatkan brightness saat ini
get_brightness() {
    cat "$BRIGHTNESS_FILE"
}

# Fungsi mengatur brightness
set_brightness() {
    echo "$1" > "$BRIGHTNESS_FILE"
}

# Fungsi menaikkan brightness
increase_brightness() {
    CUR=$(get_brightness)
    MAX=$(cat "$MAX_BRIGHTNESS_FILE")
    NEW=$((CUR + STEP))

    if [ "$NEW" -gt "$MAX" ]; then
        NEW="$MAX"
    fi

    set_brightness "$NEW"
}

# Fungsi menurunkan brightness
decrease_brightness() {
    CUR=$(get_brightness)
    NEW=$((CUR - STEP))

    if [ "$NEW" -lt 0 ]; then
        NEW=0
    fi

    set_brightness "$NEW"
}

# Menjalankan perintah berdasarkan argumen
case "$1" in
    get)
        get_brightness
        ;;
    up)
        increase_brightness
        ;;
    down)
        decrease_brightness
        ;;
    set)
        set_brightness "$2"
        ;;
    *)
        echo "Usage: $0 {get|up|down|set <value>}"
        exit 1
        ;;
esac
