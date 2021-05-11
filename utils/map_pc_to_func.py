#!/usr/bin/env python3

import re
import os
import sys

lines = open('all.txt').readlines()
matches = [re.match('(\w+) <(\w+)>:', line.strip()) for line in lines]
symbols = [[int(m[1][-10:], 16), m[2]] for m in matches if m]
symmap = dict(symbols)

def find_func(pc, table):
  pre_func = 'N/A'
  for addr, func in table:
    if pc == addr:
      return func
    elif pc > addr:
      pre_func = func
    else:
      return pre_func

trace = [line.strip() for line in open('trace').readlines()]
trace = [int(t, 16) for t in trace]
for pc in trace:
  print(find_func(pc, symbols))
