#!/bin/bash
# day4 - part1

# pass input via stdin with trailing line

while read comp
do
  # split on hyphen and commas and set to args like in p1
  IFS='-,'
  set $comp
  IFS=
  
  # using double eval for brace expansion on positional params
  eval eval A=() A[{$1..$2}]=1
  eval B=({$3..$4})
  Ar=${#A[@]}
  Br=${#B[@]}

  # expand the other range into the first array's indices to act as a set
  eval eval A[{$3..$4}]=1

  # increment total only if there is a difference between length
  # of both arrays (index used as a set) and the full array
  ((Ar+Br-${#A[@]})) && let ++total
done

echo $total