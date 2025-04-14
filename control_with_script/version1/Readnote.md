## A little guide

1. install udevd jika belum ada:
sudo xbps-install -S udevd

2. jalankan service udevd jika belum aktif:
sudo ln -s /etc/sv/udevd /var/service/

3. buat direktori rules.d pada /etc/udev/ jika belum ada:
sudo mkdir -p /etc/udev/rules.d

4. salin file 90-brightness.rules ke /etc/udev/rules.d/ :
sudo mv 90-brightness.rules /etc/udev/rules.d/

5. buat direktori script jika belum ada:
mkdir ~/scripts

6. beri izin eksekusi:
chmod +x set-brightness.sh

7. pindahkan script set-brightness.sh ke direktori ~/scripts
mv set-brightness.sh ~/scripts/

8. pastikan script ini bisa dijalankan langsung dari terminal:

~/scripts/set-brightness.sh up
~/script/set-brightness.sh down

9. tambahkan keybinds ke ~/.config/sxhkd/sxhkdrc:

mkdir ~/.config/sxhkd
touch ~/.config/sxhkdrc

buka file sxhkdrc dengan text editor yang anda punya
tambahkan baris berikut:

XF86MonBrightnessUp
    ~/scripts/set-brightness.sh up

XF86MonBrightnessDown
    ~/scripts/set-brightness.sh down

10. jalankan sxhkd di tempat anda biasa menyimpan file startup (kalau belum):

sxhkd &


## penjelasan isi script set-brightness.sh
```
#!/bin/sh

# Ambil direktori backlight pertama yang tersedia
backlight=$(find /sys/class/backlight/* -maxdepth 0 | head -n1)

# Ambil nilai maksimum brightness
max=$(cat "$backlight/max_brightness")

# Step kenaikan = 5% dari max
step=$(( max / 20 ))

# Baca nilai brightness saat ini
current=$(cat "$backlight/brightness")

# Tentukan arah perubahan
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

## Tulis nilai brightness baru
echo "$new" > "$backlight/brightness"
```
