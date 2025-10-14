
# PC

- Get the IP of the PC with `ip a`.
- Compile curl:
```
# Set the working environment
cd ~/development/repositories/mastering_embedded_linux_programming/yocto
source poky/oe-init-build-env build-rpi

# Build the curl package
bitbake curl

# Populate the package index
bitbake package-index
```
- Create an HTTP server:
```
# Set the working environment
cd ~/development/repositories/mastering_embedded_linux_programming/yocto/build-rpi/tmp-glibc/deploy/ipk

# Create the HTTP server
sudo python3 -m http.server --bind 192.168.1.186 80
```

# Raspberry Pi

- Edit /etc/opkg/opkg.conf so that it looks like this:
```
src/gz all http://192.168.1.186/all
src/gz cortexa72 http://192.168.1.186/cortexa72
src/gz raspberrypi4_64 http://192.168.1.186/raspberrypi4_64

dest root /
option lists_dir /var/lib/opkg/lists
```
- To install curl, execute:
```
opkg update
opkg list | grep curl
opkg install curl
curl --version
```
- Another option to upgrade all packages is:
```
opkg list-upgradable
opkg upgrade
```
