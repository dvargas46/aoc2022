#!/bin/bash
# day5 - part1 and part2

# pass input via stdin with trailing line

# mover specifications
CM=(9000 9001)

# gather data and determine how many columns there are
mapfile file
num_of_cols=$(( ${#file[0]}/4 ))
data="${file[@]}"

# collects the instruction set
instr="${data//*$'\n \n'}"
instr=${instr//[a-z$'\n']}
instr=${instr//  / }
instr=${instr/ }

# container assignment function
# uses the given data to assign all columns into an array
# each column is represented by a string of characters
# where the top of the column (stack) is actually the
# beginning of the column string
assign_containers() {
  c=()
  OIFS=$IFS
  IFS=$'\n'
  for line in \ ${data//1*}
  do
  for((i=0; i<num_of_cols; i++)){
    val=${line:i*4+2:1}
    [[ $val != ' ' ]] && c[i]+=$val
  }
  done
  IFS=$OIFS
}

# primary logic to move the crates based on the mover specification
move_crates() {
  mover=$1
  assign_containers
  while read -d' ' move
  do
    read -d' ' from
    read -d' ' to

    rem=${c[from-1]::move}
    c[from-1]=${c[from-1]:move}
    if [[ $mover == "9000" ]]; then
      for((i=0;i<${#rem};i++)){ c[to-1]=${rem:i:1}${c[to-1]};}
    elif [[ $mover == "9001" ]]; then
      c[to-1]=$rem${c[to-1]}
    else
      echo "CrateMover not implemented or missing: $mover"
    fi
  done <<< $instr

  printf "%.1s" ${c[@]}
  echo
}

# iterate both mover specs - solves part 1 and 2
for mover in ${CM[@]}
do
  move_crates $mover
done
