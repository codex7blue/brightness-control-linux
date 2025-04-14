#!/bin/sh

CONFIG_FILE="/usr/local/bin/.brightness-keys.conf"

if [ -f "$CONFIG_FILE" ]; then
    echo "Deleted old brightness configuration..."
    rm -f "$CONFIG_FILE"
    echo "Configuration reset. when the service is run again, it will auto detect again."
else
    echo "No previous brightness configuration found."
fi