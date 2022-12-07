#!/bin/bash
# day6 - part1 and part2

# pass input via stdin with trailing line
read buf

find_marker() {
  len=$(($1))
  
  for((;i<${#buf};i++))
  do
    marker=${buf:i:len}
    found=1
    for((j=0;j<len;j++)){
      tmp=${marker//${marker:j:1}}
      [[ ${#tmp} -ne len-1 ]] && found=0
    }
    [[ found -ne 0 ]] && break
  done

  echo $marker
  echo $((i+len))
}

# part 1
find_marker 4

# part 2
find_marker 14