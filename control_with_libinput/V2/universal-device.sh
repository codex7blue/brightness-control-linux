#!/bin/sh

CONFIG_FILE="/usr/local/bin/.brightness-keys.conf"

# Function: auto-detect device event
detect_event_device() {
    libinput list-devices | awk '
      /Device:/ {dev=$0}
      /Kernel:/ {
        match($0, /event[0-9]+/, a)
        path="/dev/input/" a[0]
        if (path != "") print path
      }
    ' | while read -r device; do
        echo "Try detecting brightness key in $device..."
        timeout 5 libinput debug-events --device "$device" > /tmp/brightness-test.log &
        PID=$!
        echo "Please press the brightness UP and DOWN button in 5 second..."
        sleep 6
        kill "$PID" 2>/dev/null

        grep -q "KEY_BRIGHTNESS" /tmp/brightness-test.log && {
            echo "$device" && return
        }
    done
}

# Function: detect & save pattern key brightness
detect_key_pattern() {
    echo "Detect brightness button pattern..."
    echo "Please press the brightness UP and DOWN button in 5 second..."

    timeout 5 libinput debug-events --device "$1" > /tmp/brightness-keys.log
    UP_KEY=$(grep "KEY_BRIGHTNESSUP" /tmp/brightness-keys.log | head -n1 | sed 's/.*\(KEY_BRIGHTNESSUP[^ ]*\).*/\1/')
    DOWN_KEY=$(grep "KEY_BRIGHTNESSDOWN" /tmp/brightness-keys.log | head -n1 | sed 's/.*\(KEY_BRIGHTNESSDOWN[^ ]*\).*/\1/')

    if [ -n "$UP_KEY" ] && [ -n "$DOWN_KEY" ]; then
        echo "DEVICE=$1" > "$CONFIG_FILE"
        echo "KEY_UP=$UP_KEY" >> "$CONFIG_FILE"
        echo "KEY_DOWN=$DOWN_KEY" >> "$CONFIG_FILE"
        echo "Pattern saved successfully $CONFIG_FILE"
    else
        echo "Failed to detect key pattern. please try again."
        exit 1
    fi
}

# If there is no config. auto detect
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Brightness configuration is not available yet. starting detection..."
    DEVICE=$(detect_event_device)
    [ -z "$DEVICE" ] && { echo "No input device found with brightness button."; exit 1; }
    detect_key_pattern "$DEVICE"
fi

# Load config
. "$CONFIG_FILE"

# Run monitor with saved key pattern
echo "Monitoring brightness keys in $DEVICE (UP: $KEY_UP, DOWN: $KEY_DOWN)..."
libinput debug-events --device "$DEVICE" | while read -r line; do
    case "$line" in
        *"$KEY_UP"*"pressed"*)
            /usr/local/bin/brightness.sh up
            ;;
        *"$KEY_DOWN"*"pressed"*)
            /usr/local/bin/brightness.sh down
            ;;
    esac
done