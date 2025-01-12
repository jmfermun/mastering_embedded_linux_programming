Testing environment for the examples in the book Mastering Embedded Linux Programming (Third-Edition).

Links of interest:
- https://www.packtpub.com/en-us/product/mastering-embedded-linux-programming-9781789530384
- https://github.com/PacktPublishing/Mastering-Embedded-Linux-Programming-Third-Edition

Notes:
- Steps needed to change the repository directory to be case sensitive (needed by crosstool NG):
    1. Open PowerShell as Administrator.
    1. The method needs an empty <directory_path>.
    1. Execute ```fsutil.exe file setCaseSensitiveInfo <directory_path> enable```.
- Steps needed to use crosstool NG with root user:
    1. Execute ```bin/ct-ng menuconfig```.
    1. Select ```Paths and misc options --->```.
    1. Pres Y over ```Try features marked as EXPERIMENTAL```.
    1. Pres Y over ```Allow building as root user (READ HELP!) (NEW)```.
    1. Pres Y over ```Are you sure? (NEW)```.
    1. Save the configuration.
- Steps needed to enable git long paths:
    1. Open git bash.
    1. Execute ```git config --global core.longpaths true```.
- Steps needed to configure Git Large File Storage:
    1. Open git bash.
    1. Execute ```git lfs track "*.tar.gz"```.
