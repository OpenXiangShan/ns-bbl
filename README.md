# ns-bbl

A standalone and integrated repo to build riscv-linux based image fitting FPGA prototype.

# How To

```
cd ns-bbl
make init -j
make sw -j
```

Program `build/linux.bin` is the generated image for FPGA prototype

# nanhu compatibility

For Nanhu micro-architecture FPGA prototype under BOSC environment, workflow is a little bit different. Please follow these steps:

1. Apply several patches in ./nanhu-patch dir

2. Prepare rootfsimg and configure linux kernel (./nanhu-linux.config is recommanded)

3. Run either fpga-build.sh or spec-build.sh to build the image

4. We use memory injection technology based on JTAG to setup workload. To this end, we need to convert the image to a specific format. Use bin2data.sh or spec_bin2data.py according to demand.

# southlake compatibility

Soutlake branch is almost the same with Nanhu except the address map, which means only the riscv-pk is different with Nanhu.

In the nanhu-patch dir, riscv-pk's and riscv-rootfs' patch is already applied and no longer needed. The riscv-linux patch will return static value for random read.

In the dts(platform.dtsi --> noop.dtsi), only simple device, memory/plic/clint.. are supported. Others device are not supported.(But they are the same with Nanhu with different address).

Other steps is the same with Nanhu.
