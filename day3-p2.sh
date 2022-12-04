#!/bin/bash
# day3 - part2

# pass input via stdin with trailing line

# sets each letter to a value corresponding to the priorities
eval let {a..z}=++_ {A..Z}=++_

while read line1
do
  read line2
  read line3
  match12=${line2//[$line1]}
  common=${line2//[$match12]}
  [[ $line3 =~ [$common] ]]
  let sum+=BASH_REMATCH
done

echo $sum