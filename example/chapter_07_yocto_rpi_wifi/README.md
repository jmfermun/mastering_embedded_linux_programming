# WiFi configuration

```
lsmod | grep 80211

connmanctl
connmanctl> enable wifi
connmanctl> agent on
connmanctl> scan wifi
connmanctl> services
# Search for a line like: DIGIFIBRA-PLUS-AD67  wifi_d83adde62988_4449474946494252412d504c55532d41443637_managed_psk
connmanctl> connect wifi_d83adde62988_4449474946494252412d504c55532d41443637_managed_psk
# Insert WiFi password
Passphrase? ****
connmanctl> services
connmanctl> quit
```

# Bluetooth configuration

```
lsmod | grep bluetooth

btuart

connmanctl
connmanctl> enable bluetooth
connmanctl> quit

bluetoothctl
[bluetooth]# default-agent
[bluetooth]# power on
[bluetooth]# show
[bluetooth]# scan on
[bluetooth]# scan off
# Search for a line like: [NEW] Device XX:XX:XX:XX:XX:XX A33 de Juan Manuel
[bluetooth]# pair XX:XX:XX:XX:XX:XX
# Accept pair in the phone
[agent] Confirm passkey 404937 (yes/no): yes
[bluetooth]# connect XX:XX:XX:XX:XX:XX
[A33 de Juan Manuel]# quit
```
