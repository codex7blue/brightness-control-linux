#!/bin/sh

sudo mkdir -p /etc/udev/rules.d/
sudo mv 90-brightness.rules /etc/udev/rules.d/

sudo mv brightness.sh /usr/local/bin/
sudo mv libinput-brightness.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/brightness.sh
sudo chmod +x /usr/local/bin/libinput-brightness.sh

sudo mkdir -p /etc/sv/libinput-brightness/
sudo mv run /etc/sv/libinput-brightness/
sudo chmod +x /etc/sv/libinput-brightness/run

sudo ln -s /etc/sv/libinput-brightness /var/service/
