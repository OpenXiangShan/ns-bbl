set -ex

export RISCV_ROOTFS_HOME=`pwd`/riscv-rootfs
export SPEC=/nfs/home/share/xs-workloads/spec/spec-all

mkdir -p spec_output
mkdir -p spec_dump

for i in $(cat spec_list)
do
    echo Build $i...
    rm -rf riscv-pk/build
    rm -rf riscv-linux/vmlinux
    cd riscv-rootfs/rootfsimg
    python3 ./spec_gen.py $i
    cd -
    make sw -j16
    mv build/vmlinux.txt spec_dump/vmlinux-$i.txt
    mv build/bbl.txt spec_dump/bbl-$i.txt
    mv build/linux.bin spec_output/$i.bin
done
