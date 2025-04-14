## how to setup

open <mark>/etc/sudoers</mark>
add line:
```
username ALL=(ALL) NOPASSWD: /usr/bin/tee /sys/class/backlight/*/brightness
```
change **username** to your specific username

give execute acces to **set-brightness.sh**
```
sudo chmod +x set-brightness.sh
```
move **set-brightness.sh** to direktori <mark>~/scripts/</mark> or <mark>/usr/local/bin/</mark>
