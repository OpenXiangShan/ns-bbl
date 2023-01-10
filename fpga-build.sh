rm -rf build
mkdir build
rm -rf riscv-pk/build
rm -rf riscv-linux/vmlinux
#make clean -C riscv-linux -j128
make clean -C riscv-pk -j128
export RISCV_ROOTFS_HOME=`pwd`/riscv-rootfs
make sw -j128
./bin2data.sh build/linux.bin ./build/linux.bin.txt

