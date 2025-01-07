Testing environment for the examples in the book Mastering Embedded Linux Programming (Third-Edition).

Links of interest:
- https://www.packtpub.com/en-us/product/mastering-embedded-linux-programming-9781789530384
- https://github.com/PacktPublishing/Mastering-Embedded-Linux-Programming-Third-Edition

Notes:
- Steps needed to change the repository directory to be case sensitive (needed by crosstool NG):
    1. Open PowerShell as Administrator.
    2. The method needs an empty <directory_path>.
    3. Execute the following command changing <directory_path> with the desired one:
    ```
    fsutil.exe file setCaseSensitiveInfo <directory_path> enable
    ```
