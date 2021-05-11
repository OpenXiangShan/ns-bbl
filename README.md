# Nanshan BBL (NSBL?)

A standalone and integrated repo to build riscv-linux image fitting Nanshan FPGA prototype.

# How To

```
git clone <this.git>
cd ns-bbl
make init -j # important
make sw -j
```

Program `build/linux.bin` into qspi flash for Nanshan FPGA prototype.
