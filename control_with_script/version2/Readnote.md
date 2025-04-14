## how to setup

open /etc/sudoers
add line:
```
username ALL=(ALL) NOPASSWD: /usr/bin/tee /sys/class/backlight/*/brightness
```
change <mark>username</mark>to your specific username

give execute acces to set-brightness.sh
```
sudo chmod +x set-brightness.sh
```
move set-brightness.sh to direktori ~/scripts/ or <mark>/usr/local/bin/</mark>
