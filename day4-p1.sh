#!/bin/bash
# day4 - part1

# pass input via stdin with trailing line

while read comp
do
  # split on hyphen and commas
  IFS='-,'

  # map to args
  set $comp
  IFS=

  # increment total whenever the entire range is within the other
  let "total+=(($3-$1>=0 && $2-$4>=0) || ($1-$3>=0 && $4-$2>=0))"
done

echo $total