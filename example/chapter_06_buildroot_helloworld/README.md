- Copy folder helloworld into buildroot/packages.
- Add to buildroot/packages/Config.in:
```
menu "My programs"
    source "package/helloworld/Config.in"
endmenu
```
- Run:
```
cd ~/development/repositories/mastering_embedded_linux_programming/buildroot
make O=./build/bbb menuconfig
# Target packages -> My programs -> helloworld -> Press Y -> Save and exit
make O=./build/bbb
```