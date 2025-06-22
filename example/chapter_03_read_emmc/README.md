# Read eMMC

```
# List MMC devices
mmc list

# Select eMMC, for example, "1"
mmc dev 1

# Show eMMC information
# Start sector: 8192 (0x2000; address = 8192 * 512 B = 0x400000)
# Num Sectors: 7468288 (size = 7468288 * 512 B / 2**30 = 3.56GiB)
mmc info
mmc part

# Show RAM info
# DRAM bank 0 -> start: 0x80000000
# DRAM bank 0 -> size: 0x20000000 (0x20000000 / 2**20 = 512 MiB)
bd info

# Load eMMC into RAM
# - RAM start address: 80000000 (DRAM bank 0 start)
# - eMMC start block: 2000 (eMMC start sector)
# - eMMC block count: E0000 (448 MiB * 2**20 / 512 B = 0xE0000 sectors)
mmc read 80000000 2000 E0000
```
