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
  for((j=0; j<${#row}; j++));{
    map[$index,$j]=$((${row:j:1}))
    distmap[$index,$j]=$MAX_N
  }
}

mapfile -t -c1 -C'setup'
let x=start_x
let y=start_y
let max_x=${#matrix[0]}
let max_y=${#matrix[@]}

distmap[$x,$y]=0

explore() {
  cost=1 # cost to move
  vr=$((map[$x,$y]+1))
  dn=$((distmap[$x,$y]+cost))

  # check up
  ny=$((y-1))
  if (( y>0 && !visted[$x,$ny] && map[$x,$ny]<=vr && distmap[$x,$ny]>dn))
  then
    distmap[$x,$ny]=$dn
    parent[$x,$ny]=$x,$y
    next_potential[$x,$ny]=$dn
  fi

  # check down
  ny=$((y+1))
  if (( y<max_y && !visted[$x,$ny] && map[$x,$ny]<=vr && distmap[$x,$ny]>dn))
  then
    distmap[$x,$ny]=$dn
    parent[$x,$ny]=$x,$y
    next_potential[$x,$ny]=$dn
  fi

  # check left
  nx=$((x-1))
  if ((x>0 && !visted[$nx,$y] && map[$nx,$y]<=vr && distmap[$nx,$y]>dn))
  then
    distmap[$nx,$y]=$dn
    parent[$nx,$y]=$x,$y
    next_potential[$nx,$y]=$dn
  fi

  # check right
  nx=$((x+1))
  if ((x<max_x && !visted[$nx,$y] && map[$nx,$y]<=vr && distmap[$nx,$y]>dn))
  then
    distmap[$nx,$y]=$dn
    parent[$nx,$y]=$x,$y
    next_potential[$nx,$y]=$dn
  fi

  visted[$x,$y]=1

  # find next priority path
  unset sorted
  for coord in ${!next_potential[@]};{
    sorted[next_potential[$coord]]=$coord
  }
  nc=${sorted[@]::1}
  x=${nc//,*}
  y=${nc//*,}
  for k in ${!next_potential[@]};{ echo $k: ${next_potential[$k]};}

  unset next_potential[$nc]
  echo chose: $x,$y

  if (( x==end_x && y==end_y ))
  then
    found=1
  fi
}

while ((!found))
do
  explore
done
