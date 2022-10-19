# Nanshan BBL

Build riscv-linux image fitting Nanshan Chip.

# Features

- [x] SPI FLASH
- [x] UART
- [x] DDR4
- [x] GMAC
- [x] SDMMC

# How-To

```
git clone https://github.com/RISCVERS/ns-bbl
cd ns-bbl
source env.sh # check to match your env
make init -j # important
make sw -j
```

If an error occurs (usually some app in rootfs fails),
   check output and go to that directory to mannually clean and make.

Program `build/linux.bin` into qspi flash for Nanshan Chip.
