# check RISCV environment variable
ifndef RISCV
$(error Please set environment variable RISCV. Please take a look at README)
endif

build_dir = $(realpath ./build)
SW_PATH = $(abspath .)

$(SW_PATH):
	@echo "Do you want to put all software repos under $(SW_PATH) (You can modify 'SW_PATH' in Makefile.sw)? [y/n]"
	@read r; test $$r = "y"
	mkdir -p $(SW_PATH)

#--------------------------------------------------------------------
# Build tools
#--------------------------------------------------------------------

RISCV_PREFIX=riscv64-unknown-linux-gnu-
CC = $(RISCV_PREFIX)gcc
LD = $(RISCV_PREFIX)ld
RISCV_COPY = $(RISCV_PREFIX)objcopy
RISCV_COPY_FLAGS = --set-section-flags .bss=alloc,contents --set-section-flags .sbss=alloc,contents -O binary
RISCV_DUMP = $(RISCV_PREFIX)objdump

#--------------------------------------------------------------------
# BBL variables
#--------------------------------------------------------------------

BBL_REPO_PATH = $(SW_PATH)/riscv-pk

BBL_BUILD_PATH = $(BBL_REPO_PATH)/build
BBL_ELF_BUILD = $(BBL_BUILD_PATH)/bbl

BBL_PAYLOAD = $(LINUX_ELF)
BBL_CONFIG = --host=riscv64-unknown-elf --with-arch=rv64imac --with-payload=$(BBL_PAYLOAD) --enable-logo
#--enable-boot-machine

BBL_ELF = $(build_dir)/bbl.elf
BBL_BIN = $(build_dir)/linux.bin

BBL_VMF = $(build_dir)/bbl.vmf
BBL_TXT = $(build_dir)/bbl.txt

BBL_DTB = $(BBL_BUILD_PATH)/system.dtb
BBL_DTS = $(shell find -type f $(BBL_REPO_PATH)/dts)

#--------------------------------------------------------------------
# Linux variables
#--------------------------------------------------------------------

LINUX_REPO_PATH = $(SW_PATH)/riscv-linux

LINUX_ELF_BUILD = $(LINUX_REPO_PATH)/vmlinux
LINUX_ELF = $(build_dir)/vmlinux
LINUX_TXT = $(build_dir)/vmlinux.txt

ROOTFS_PATH = $(SW_PATH)/riscv-rootfs
RFS_ENV = RISCV_ROOTFS_HOME=$(ROOTFS_PATH)

#--------------------------------------------------------------------
# BBL rules
#--------------------------------------------------------------------

bbl: $(BBL_BIN)

$(BBL_BIN): $(BBL_ELF)
	$(RISCV_COPY) $(RISCV_COPY_FLAGS) $< $@
	$(RISCV_COPY) -I binary -O verilog $(BBL_BIN) $(BBL_VMF)
	$(RISCV_DUMP) -d $(BBL_ELF) > $(BBL_TXT)

$(BBL_ELF): $(BBL_ELF_BUILD)
	ln -sf $(abspath $<) $@

$(BBL_REPO_PATH): | $(SW_PATH)
	mkdir -p $@

$(BBL_BUILD_PATH): $(BBL_PAYLOAD)
	mkdir -p $@
	cd $@ && $(BBL_REPO_PATH)/configure $(BBL_CONFIG)

$(BBL_DTB): $(BBL_DTS) | $(BBL_BUILD_PATH)
	dtc $(BBL_REPO_PATH)/dts/system.dts -o $@

$(BBL_ELF_BUILD): $(BBL_DTB) | $(BBL_BUILD_PATH)
	cd $(@D) && $(RFS_ENV) $(MAKE)

bbl-clean:
	-rm $(BBL_ELF) $(BBL_BIN)
	-$(RFS_ENV) $(MAKE) clean -C $(BBL_BUILD_PATH)

.PHONY: bbl bbl-clean $(BBL_ELF_BUILD)

#--------------------------------------------------------------------
# Linux rules
#--------------------------------------------------------------------

linux: $(LINUX_ELF)

$(LINUX_ELF): $(LINUX_ELF_BUILD)
	ln -sf $(abspath $<) $@
	$(RISCV_DUMP) -d $(LINUX_ELF) > $(LINUX_TXT)

$(LINUX_ELF_BUILD):
	$(RFS_ENV) $(MAKE) -C $(ROOTFS_PATH)
	cd $(@D) && $(RFS_ENV) $(MAKE) CROSS_COMPILE=$(RISCV_PREFIX) ARCH=riscv vmlinux

linux-clean:
	-rm $(LINUX_ELF)
	-$(RFS_ENV) $(MAKE) clean -C $(LINUX_REPO_PATH)

.PHONY: linux linux-clean $(LINUX_ELF_BUILD)


#--------------------------------------------------------------------
# Software top-level rules
#--------------------------------------------------------------------

sw: bbl

sw-clean: bbl-clean linux-clean
	-$(RFS_ENV) $(MAKE) -C $(ROOTFS_PATH) clean

init:
	git submodule update --init --depth 1 riscv-linux
	git submodule update --init           riscv-pk
	git submodule update --init           riscv-rootfs
	cp riscv-linux.config riscv-linux/.config
	@/bin/echo -e "\033[1;31mPlease manually set the RISCV_ROOTFS_HOME environment variable to $(ROOTFS_PATH).\033[0m"
	mkdir build

.PHONY: sw sw-clean
