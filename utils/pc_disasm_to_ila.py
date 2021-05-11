#!/usr/bin/env python3

import re
import sys

# pc: hex pc, no 0x
# return: hex pc, no 0x, drop lsb
def pc_disasm_to_ila(pc):
  return hex((int(pc, 16) // 2) & 0x7fffffffff)[2:]

lines = open(sys.argv[1]).readlines()
before = open('ila-before-copy-and-run.txt', 'w')
after = open('ila-after.txt', 'w')

for line in lines:
  m = re.match('^ *([0-9a-fA-F]+):(.*)$', line)
  if not m:
    before.write(line)
    after.write(line)
    continue
  pc = m[1]
  inst = m[2]
  pc_qspi = '1' + pc[1:]
  pc_ila_before = pc_disasm_to_ila(pc_qspi)
  pc_ila_after = pc_disasm_to_ila(pc)
  before.write(f"  {pc_ila_before}:{inst}\n")
  after.write(f"  {pc_ila_after}:{inst}\n")

before.close()
after.close()
