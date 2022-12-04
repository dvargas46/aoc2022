#!/bin/bash
# day3 - part1

# pass input via stdin with trailing line

# sets each letter to a value corresponding to the priorities
eval let {a..z}=++_ {A..Z}=++_

while read value
do
  c1=${value::hp=${#value}/2}
  c2=${value:hp}
  [[ $c2 =~ [$c1] ]]
  let sum+=BASH_REMATCH
done

echo $sum