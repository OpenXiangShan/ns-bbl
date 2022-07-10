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
