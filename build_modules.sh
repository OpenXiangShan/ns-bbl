#!/bin/bash

build(){
    modinstall=out/mod_install
    rm -rm ${modinstall} 
    mkdir -p ${modinstall}
    #make ARCH=riscv CROSS_COMPILE=riscv64-unknown-linux-gnu- -C riscv-linux nanhu_fpga_defconfig
    make ARCH=riscv CROSS_COMPILE=riscv64-unknown-linux-gnu- -C riscv-linux  modules -j200
    make ARCH=riscv CROSS_COMPILE=riscv64-unknown-linux-gnu- -C riscv-linux  modules_install INSTALL_MOD_PATH=../${modinstall}/modules
    #make ARCH=riscv CROSS_COMPILE=riscv64-unknown-linux-gnu- -C riscv-linux  install INSTALL_PATH=../${modinstall}
    cd out/
    tar zcvf mod_install.tar.gz mod_install
    cd ../
}
build

