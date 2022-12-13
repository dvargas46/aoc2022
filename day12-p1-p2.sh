#!/bin/bash
# day12 - part1 and part2
# NOTE: for part2, I modified the input left column to put S
#       in various starting positions in order to find the
#       shortest path.
#
# pass input via stdin with trailing line
#

# apply weights to all map values
let {a..z}=++weight E=27

declare -A next_potential
declare -A visited
declare -A distmap
declare -A map
declare -A parent

MAX_N=$((2**63-1))

setup() {
  index=$1
  row=$2
  matrix+=($row)

  # find start and end
  [[ $row =~ S ]] && temp=${row//S*} && let start_x=${#temp} start_y=index
  [[ $row =~ E ]] && temp=${row//E*} && let end_x=${#temp} end_y=index

  # init distance map
  for((col=0; col<${#row}; col++));{
    map[$col,$index]=$((${row:col:1}))
    distmap[$col,$index]=$MAX_N
  }
}

mapfile -t -c1 -C'setup'
let xp=start_x
let yp=start_y
let max_x=${#matrix[0]}-1
let max_y=${#matrix[@]}-1

distmap[$xp,$yp]=0

explore() {
  cost=1 # cost to move
  vr=$((map[$xp,$yp]+1))
  dn=$((distmap[$xp,$yp]+cost))

  # check up
  let yn=yp-1
  if (( yp>0 && !visited[$xp,$yn] && map[$xp,$yn]<=vr && distmap[$xp,$yn]>dn))
  then
    distmap[$xp,$yn]=$dn
    parent[$xp,$yn]=$xp,$yp
    next_potential[$xp,$yn]=$dn
  fi

  # check down
  let yn=yp+1
  if (( yp<max_y && !visited[$xp,$yn] && map[$xp,$yn]<=vr && distmap[$xp,$yn]>dn))
  then
    distmap[$xp,$yn]=$dn
    parent[$xp,$yn]=$xp,$yp
    next_potential[$xp,$yn]=$dn
  fi

  # check left
  let xn=xp-1
  if (( xp>0 && !visited[$xn,$yp] && map[$xn,$yp]<=vr && distmap[$xn,$yp]>dn ))
  then
    distmap[$xn,$yp]=$dn
    parent[$xn,$yp]=$xp,$yp
    next_potential[$xn,$yp]=$dn
  fi

  # check right
  let xn=xp+1
  if (( xp<max_x && !visited[$xn,$yp] && map[$xn,$yp]<=vr && distmap[$xn,$yp]>dn ))
  then
    distmap[$xn,$yp]=$dn
    parent[$xn,$yp]=$xp,$yp
    next_potential[$xn,$yp]=$dn
  fi

  visited[$xp,$yp]=1

  # find next priority path
  unset sorted
  for coord in ${!next_potential[@]};{
    sorted[next_potential[$coord]]=$coord
  }
  nc=${sorted[@]::1}
  xp=${nc//,*}
  yp=${nc//*,}

  [[ -z $xp ]] && [[ -z $yp ]] && found=1 && echo DID NOT FIND END && break

  unset next_potential[$nc]
  if (( xp==end_x && yp==end_y ))
  then
    found=1
    steps=${distmap[$nc]}
  fi
}

while ((!found))
do
  explore
done
echo start: $start_x,$start_y
echo goal: $end_x,$end_y
echo steps: $steps
