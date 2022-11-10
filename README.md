# ns-bbl

A standalone and integrated repo to build riscv-linux based image fitting FPGA prototype.

There are three submodules: riscv-linux, riscv-pk, riscv-rootfs.

riscv-linux: the linux

riscv-pk: use bbl to boot linux, mainly modification: dts/uart/boot procedure

riscv-rootfs: file system, mainly modification: busybox/workload(spec/hello/memtester...)

# How To

```
cd ns-bbl
make init -j
make sw -j
```

Program `build/linux.bin` is the generated image for FPGA prototype

# nanhu compatibility

For Nanhu micro-architecture FPGA prototype under BOSC environment, workflow is a little bit different. Please follow these steps:

1. Prepare rootfsimg and configure linux kernel (./nanhu-linux.config is recommanded)

2. Run either fpga-build.sh or spec-build.sh to build the image

3. We use memory injection technology based on JTAG to setup workload. To this end, we need to convert the image to a specific format. Use bin2data.sh or spec_bin2data.py according to demand.


# Nanhu FPGA spec06 generation TLDR:

1. make init -j

2. ls nanhu-patch # There are several patches

3. cp nanhu-linux.config riscv-linux/.config

4. ./spec-build.sh # wait and the spec06 bin is at spec_output dir

5. ./spec_bin2data.py # wait and the spec06 data.txt is at spec_fpgadata dir
