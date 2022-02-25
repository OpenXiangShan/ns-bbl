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
make init -j # important
make sw -j
```

Program `build/linux.bin` into qspi flash for Nanshan Chip.
