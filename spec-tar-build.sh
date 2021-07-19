set -ex

mkdir -p spec_tar_output

SPECS=$(cat spec_list | grep -v "^-")
echo Build $SPECS
rm -rf riscv-pk/build
cd riscv-rootfs/rootfsimg
python3 ./spec_gen.py $SPECS
cd -
make sw -j16
du -sh build/linux.bin
OUTPUT=$(echo $SPECS | sed 's/ /_/g')
mv build/linux.bin spec_tar_output/$OUTPUT.bin
