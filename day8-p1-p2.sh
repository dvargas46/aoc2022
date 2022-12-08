#!/bin/bash
# day7 - part1 and part2

# pass input via stdin with trailing line

declare -A track
mapfile -t grid
let x=${#grid[0]} y=${#grid[@]}

# part1

# function used for checking whether the current tree is taller than the tallest seen tree
check() { (( n=${grid[yi]:xi:1}, n>m?m=n:0 )) && track[$xi,$yi]+=$1;}

# checking UP and DOWN
for((xi=1; xi<x-1; xi++)){
  m=${grid[0]:xi:1}
  for((yi=1; m<9 && yi<y-1; yi++)){ check U;}

  m=${grid[y-1]:xi:1}
  for((yi=y-2; m<9 && yi>0; yi--)){ check D;}
}

# checking LEFT and RIGHT
for((yi=1; yi<y-1; yi++)){
  m=${grid[yi]:0:1}
  for((xi=1; m<9 && xi<x-1; xi++)){ check L;}

  m=${grid[yi]:x-1:1}
  for((xi=x-2; m<9 && xi>0; xi--)){ check D;}
}
echo $(( ${#track[@]} + 2*(x-1) + 2*(y-1) ))


# part 2

# we only need to check the inner trees because the edge trees will always have a 
# view distance of 0 in one direction making the overall product 0
for coord in ${!track[@]};{
  xj=${coord/,*}
  yj=${coord/*,}

  # every view distance starts at 1
  for((uc=1, yi=yj+1; yi<y-1 && ${grid[yj]:xj:1} > ${grid[yi]:xj:1}; yi++)){ let ++uc;}
  for((dc=1, yi=yj-1; yi>0   && ${grid[yj]:xj:1} > ${grid[yi]:xj:1}; yi--)){ let ++dc;}
  for((lc=1, xi=xj+1; xi<x-1 && ${grid[yj]:xj:1} > ${grid[yj]:xi:1}; xi++)){ let ++lc;}
  for((rc=1, xi=xj-1; xi>0   && ${grid[yj]:xj:1} > ${grid[yj]:xi:1}; xi--)){ let ++rc;}

  # calulate product and add to indexed array for sorting behavior
  let val=uc*dc*lc*rc
  view[val]=$val
}

echo ${view[-1]}
