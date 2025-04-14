#!/bin/sh

# Install all script
sudo mkdir -p /usr/local/bin/
sudo cp brightness.sh universal-device.sh reset-brightness-config.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/*.sh

# Prepare a runit service
sudo mkdir -p /etc/sv/libinput-brightness/
sudo cp run finish /etc/sv/libinput-brightness/
sudo chmod +x /etc/sv/libinput-brightness/run /etc/sv/libinput-brightness/finish

# Enable service
sudo ln -sf /etc/sv/libinput-brightness /var/service/

echo "Finish setup. Run the command 'sudo sv status libinput-brightness' for check the service."