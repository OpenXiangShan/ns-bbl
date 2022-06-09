rm -rf riscv-pk/build
rm -rf riscv-linux/vmlinux
make clean -C riscv-linux
export RISCV_ROOTFS_HOME=`pwd`/riscv-rootfs
make sw -j16
