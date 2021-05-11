#!/usr/bin/env python3

import csv
import re
import sys
import os

K_VALID = 'ns_soc/u_cpu_ddr_subsys_wrap/XSTop0/dut/tile_fpga_trace_traces_0_valid'
K_PC = 'ns_soc/u_cpu_ddr_subsys_wrap/XSTop0/dut/tile_fpga_trace_traces_0_commPC[39:1]'

with open('iladata.csv') as csvfile:
  reader = csv.DictReader(csvfile)
  for row in reader:
    if row[K_VALID] == '1':
      pc = row[K_PC]
      print(pc)
      pc = hex(int(pc, 16) * 2)
      pc = pc[2:]
      if pc[0] == '8':
        pc = '00' + pc
      #print(pc)
