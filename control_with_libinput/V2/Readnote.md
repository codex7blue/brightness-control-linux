## structure file script
```
brightness-control v2/
├── universal-device.sh            # listener brightness button (smart)
├── brightness.sh                  # brightness control up/down/get/set
├── run                            # script runit: restore + listener
├── finish                         # script runit: save brightness
├── reset-brightness-config.sh     # remove config button detection
├── setup-brightness.sh           # automatic setup all
```

## how to use

1. Copy all files to V2 folder if not already

2. Run the command:

```cd V2
       chmod +x setup-brightness.sh
       sudo ./setup-brightness.sh
```
3. Press the brightness button if promped

4. For reset
``` sudo reset-brightness-config.sh
```