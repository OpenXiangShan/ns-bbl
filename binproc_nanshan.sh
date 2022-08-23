#!/usr/bin/env bash

if [ -z "$1" ];
then
  echo "$0 <binary_file_path>"
  exit -1
fi

FILE="$1"

cp $FILE .tmp_bin
SIZE=$(wc -c $FILE | awk '{print $1}')
PADDING=$((1024 - $SIZE % 1024))
if ! [ $PADDING -eq 1024 ];
then
  dd if=/dev/zero bs=1 count=$PADDING >> .tmp_bin
fi

# Output 1024 bytes per line, eacy seperated by space.
od -v -A x -t x1 -w1024 .tmp_bin > bin.txt
rm .tmp_bin

# Maybe awk can also work.
py_script="
import sys
i = 0x80000000
for line in sys.stdin:
  line = line.rstrip()
  lines = line.split(' ')[1:]
  lines.reverse()
  if not line or not lines:
    break
  print(f\"{hex(i)[2:]}\")
  print(''.join(lines))
  i += 1024
"

cat bin.txt | python3 -c "$py_script" > data.txt
