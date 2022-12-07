#!/bin/bash
# day7 - part1 and part2

# pass input via stdin with trailing line

# associative array to keep track of the overall directory tree and their sizes
declare -A tree

# push and pop functions act like the bash pushd and popd stack commands, without needing the dir to exist
# it also keeps track of the total dirs pushed to the stack in the order they were pushed
push() { ((${#stack})) && dir="${stack[-1]}$1/" || dir="$1"; stack+=($dir); mstack+=($dir);}
pop() { unset stack[-1];}

# function to add the amount supplied to the entire directory stack
add() { for key in ${stack[@]};{ tree[$key]=$(( tree[$key] + $1 ));};}

# read input only caring when we are entering or exiting a directory AND calculating new sizes
while read inp
do
  case $inp in
    '$ cd ..')
      pop
      ;;

    '$ cd '[^.]*)
      push ${inp/* }
      ;;

    [0-9]*)
      add ${inp//[^0-9]}
      ;;

  esac
done

# part 1
for dir in ${mstack[@]};{
  (( tree[$dir] < 100000 )) && let total+=tree[$dir]
}
echo $total

# part 2
goal=$(( 30000000-(70000000-${tree[$mstack]}) ))
for dir in ${mstack[@]};{
  (( tree[$dir] >= goal )) && matches[${tree[$dir]}]=$dir
}
keys="${!matches[@]}"
smallest=${keys/ *}
echo ${matches[$smallest]} $smallest
