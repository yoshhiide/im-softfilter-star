#!/bin/bash

if [ $# -ne 1 ]; then
  echo "1 argument is required."
  exit 1
fi

infile=$1
workdir=$(dirname "$infile")
filename=$(basename "$infile")
name=${filename%.*}
ext=${filename##*.}
workprefix="${workdir%/}/${name}"

# Create mask
convert $infile -threshold 94% "${workprefix}_mask_threshold.${ext}"
convert "${workprefix}_mask_threshold.${ext}" -negate -blur 0x25+5% "${workprefix}_mask1.${ext}"
convert "${workprefix}_mask_threshold.${ext}" -negate -blur 0x20+5% "${workprefix}_mask2.${ext}"
convert "${workprefix}_mask_threshold.${ext}" -negate -blur 0x10+25% "${workprefix}_mask3.${ext}"
convert "${workprefix}_mask1.${ext}" "${workprefix}_mask2.${ext}" "${workprefix}_mask3.${ext}" -compose darken -flatten "${workprefix}_mask.${ext}"

# Blur masking
convert $infile -mask "${workprefix}_mask.${ext}" -blur 0x20 -modulate 200 +mask "${workprefix}_softfiltered.${ext}"
