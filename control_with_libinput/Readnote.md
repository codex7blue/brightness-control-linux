## Panduan Setup Brightness Control dengan libinput + runit

1. Pastikan paket <mark>libinput</mark>sudah terinstall:
   ```sudo xbps-install -S libinput
   ```
2. Cek device brightness key dengan:
   ```sudo libinput list-devices
   ```
   Cari device bernama:
  ``` Device: Video Bus
          Kernel: /dev/input/eventX  <== catat eventX yang sesuai (misal: /dev/input/event4)
  ```
3. Tes apakah device tersebut benar:
```
   sudo libinput debug-events --device /dev/input/eventX
```
   Tekan tombol khusus brightness up dan down di keyboard kalian,
   pastikan muncul output seperti contoh:
```KEY_BRIGHTNESSUP (225) pressed 
       KEY_BRIGHTNESSDOWN (224) pressed 
```
   ini sangat penting karena output-nya harus sesuai untuk di tulis pada file script <mark>libinput-brightness.sh</mark>:
```
#!/bin/sh

libinput debug-events --device /dev/input/event* | while read -r line; do
    case "$line" in
        *"........................................................................."*)
            /usr/local/bin/brightness.sh up
            ;;
        *".........……………...................……….................."*)
            /usr/local/bin/brightness.sh down
            ;;
    esac
done
```
4. Pindahkan file script berikut ke <mark>/usr/local/bin/</mark>
   - brightness.sh
   - libinput-brightness.sh
``` sudo mv brightness.sh /usr/local/bin/ && sudo mv libinput-brightness.sh
```
5. Edit file libinput-brightness.sh, ganti: <mark>dev/input/eventX</mark>
    ubah menjadi device event yang sudah dicek di langkah 2 (misal /dev/input/event4)

6. Jadikan executable:
   ``` sudo chmod +x /usr/local/bin/brightness.sh
           sudo chmod +x /usr/local/bin/libinput-brightness.sh
   ```
7. Pastikan user anda masuk dalam grup <mark>video</mark>:
    ```sudo usermod -aG video <username>
    ```
8. Pastikan juga daemon <mark>udevd</mark>sudah terinstall, jika belum install dan jalankan service:
```sudo xbps-install -S udevd
       sudo ln -s /etc/sv/udevd /var/service/
```
9. Buat udev rule di <mark>/etc/udev/rules.d/</mark>
    Agar user yang terdaftar pada group <mark>video</mark>bisa memiliki permission ke <mark>/sys/class/backlight/* </mark>
```sudo mkdir -p /etc/udev/rules.d/
       sudo touch /etc/udev/rules.d/90-brightness.rules
```
   Buka file 90-brightness.rules
   Dan tambahkan baris:
```SUBSYSTEM=="backlight", RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness", RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"
```
   Pastikan anda bisa menulis nilai kecerahan ke device backlight anda, coba tes menggunakan perintah:
``` echo 9000 > /sys/class/backlight/*/brightness
```
   Ini penting karena script bisa berkerja jika user bisa menulis tanpa perintah <mark>sudo</mark>
   Kami juga sudah menyediakan file 90-brightness.rules dan anda bisa memindahkannya.

10. Setup service runit:
       - buat direktori file service runit
``` sudo mkdir -p /etc/sv/libinput-brightness
```
       Buat file /etc/sv/libinput-brightness/run dengan isi:
 ```
    #!/bin/sh

     exec /usr/local/bin/libinput-brightness.sh
```
      - Jadikan executable dan enable service
``` sudo chmod +x /etc/sv/libinput-brightness/run
        sudo ln -s /etc/sv/libinput-brightness /var/service/
```
     Kami juga telah menyediakan file run dan finish yang mengeksekusi perintah script <mark>libinput-brightness.sh</mark> serta-
     menyimpan dan mengembalikan level kecerahan layar setelah shutdown/reboot.

11. Cek status service:
``` sudo sv status libinput-brightness
```
12. Selesai!  
      Sekarang tombol brightness up/down akan mengatur kecerahan layar melalui script ini.

Catatan:
- Script brightness.sh menggunakan sysfs di /sys/class/backlight/*
- Jika permission ditolak, sesuaikan udev rule atau jalankan service sebagai root.



## Checklist Service libinput-brightness (Runit)

[ ] 1. Pastikan script <mark>/usr/local/bin/brightness.sh</mark>bisa diakses dan executable:
``` sudo chmod +x /usr/local/bin/brightness.sh
```
[ ] 2. Pastikan script <mark>/usr/local/bin/libinput-brightness.sh</mark> sudah:
       - Mengarah ke <mark>/dev/input/event*</mark> yang benar
       - Bisa diakses dan executable:
       ```  sudo chmod +x /usr/local/bin/libinput-brightness.sh
       ```
[ ] 3. Buat direktori service:
     ```  sudo mkdir -p /etc/sv/libinput-brightness
     ```
[ ] 4. Buat file /etc/sv/libinput-brightness/run dengan isi:
```
       #!/bin/sh

       exec /usr/local/bin/libinput-brightness.sh
```
[ ] 5. Jadikan file run executable:
```
       sudo chmod +x /etc/sv/libinput-brightness/run
```
[ ] 6. Enable service ke runit:
       sudo ln -s /etc/sv/libinput-brightness /var/service/

[ ] 7. Cek status service:
 ```      sudo sv status libinput-brightness
```
         Harusnya muncul status "run" beserta pid

[ ] 8. Cek user yang menjalankan service:
  ```  ps aux | grep libinput-brightness.sh
  ```
         Harusnya tertulis:
  ``` root     <pid>  0.0  ... /usr/local/bin/libinput-brightness.sh
  ```
[ ] 9. Tes tombol brightness:
       Tekan tombol brightness up & down
       Cek apakah brightness naik/turun

[ ] 10. Cek file brightness:
``` cat /sys/class/backlight/*/brightness
```
        Pastikan nilainya berubah saat tombol ditekan

Kalau semua checklist tercentang, berarti service sudah berjalan normal sebagai root dan brightness bisa diatur!

