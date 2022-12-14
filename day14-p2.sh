#!/bin/bash
# day14 - part2 - slight modifications from part1
# be warned, it's fairly slow. clocking in at around 2-3 mins runtime
#
# pass input via stdin with trailing line
#

declare -A grid

let x_min=2**63-1
let y_min=2**63-1

# draws the grid lines from input points
draw_line() {
  x1=${1/,*}
  y1=${1/*,}
  x2=${2/,*}
  y2=${2/*,}

  for((xt=x1, xd=x2-x1, xsig=-(xd<0)+(xd>0)+(xd==0); xt!=x2+xsig; xt+=xsig)) {
    for((yt=y1, yd=y2-y1, ysig=-(yd<0)+(yd>0)+(yd==0); yt!=y2+ysig; yt+=ysig)) {
      let "x_max = xt > x_max ? xt : x_max"
      let "x_min = xt < x_min ? xt : x_min"
      let "y_max = yt > y_max ? yt : y_max"
      let "y_min = yt < y_min ? yt : y_min"
      grid[$xt,$yt]=1
    }
  }
}

while read line
do
  prev=${line%%-?*}
  while [[ $line =~ '->' ]]
  do
    line=${line#*-?}
    next=${line%%-?*}
    draw_line $prev $next
    prev=$next
  done
done

# add the floor for part2
for((xt=0; xt<9999; xt++)){
  grid[$xt,$((y_max+2))]=1
}

# run through moving a single sand unit
move_sand() {
  x=$1
  y=$2
  stopped=0
  while (( !stopped ))
  do
    can_move_down && move_down && continue
    can_move_diagonal_left && move_diagonal_left && continue
    can_move_diagonal_right && move_diagonal_right && continue
    grid[$x,$y]=1
    stopped=1
  done
}

can_move_down() { (( !grid[$x,$((y+1))] ));}
can_move_diagonal_left() { (( !grid[$((x-1)),$((y+1))] ));}
can_move_diagonal_right() { (( !grid[$((x+1)),$((y+1))] ));}

move_down() { let ++y;}
move_diagonal_left() { let --x ++y;}
move_diagonal_right() { let ++x ++y;}

# move through all sand units until we filled to the top
y=1
while (( y!=0 )) 
do
  move_sand 500 0
  let sand_units++
done

echo $sand_units
